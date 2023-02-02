function [mx,cx,Ax,v,d,vsep,dsep,totmean,totvar]=training(trainfiles,NbreSigTrain,N,M,Msep,snratio,worldflag)

%initialisations
s=size(trainfiles,1);
feat=[];
NbClasses=length(NbreSigTrain);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(trainfiles(i,:));
   %Ajout de bruit
   %[m,ind]=max(abs(x));
   %len=min(length(x)-ind,fs/4);
   %xlevel=10*log10(sum(x(ind(1):ind(1)+len-1).^2)/len);
   xlevel=10*log10(sum(x.^2)/length(x));
   noiselevel=xlevel-snratio;
   sigmanoise=10.^(noiselevel/20);
   noise=sigmanoise*randn(1,length(x));
   x=x+noise;
   tempfeat=features(x,fs);
   %tempfeat=meddis(x);
   %tempfeat=mfcc(x,fs);
   Nbframes(i)=size(tempfeat,2);
	feat=[feat tempfeat];%Calcul des features
end;

%target
target=[];
for j=1:NbClasses, 
   start=sum(NbreSigTrain(1:j-1))+1;
   stop=sum(NbreSigTrain(1:j));
   target=[target j*ones(1,sum(Nbframes(start:stop)))]; 
end;

%Normalisation
totmean=mean(feat')';
normfeat=(feat'-repmat(totmean',size(feat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
feat=normfeat;

%Reduction PCA
v=[];d=[];
[v,d]=coveig(feat);
[redfeat]=reduce(feat,v,d,M);%unit variance
%redfeat=redfeat-repmat(mean(redfeat')',1,s);%zero-mean

%Reduction LDA
vsep=[];dsep=[];
[vsep,dsep]=separability(redfeat,target,NbClasses);
[redfeat]=reduce(redfeat,vsep,dsep,Msep,0);
feat=redfeat;%Mise en commentaire==> pas de réduction

%Rejection class features (attention: problèmes)
if (worldflag==1),
	NbRejectfeat=1500;	
	for i=1:size(feat,1),
   	maxi(i)=max(feat(i,:));
   	mini(i)=min(feat(i,:));
   	randfeat(i,:)=(maxi(i)-mini(i))*rand(1,NbRejectfeat)+mini(i);
	end;
	feat=[feat randfeat];
	target=[target (NbClasses+1)*ones(1,NbRejectfeat)];
end;

%Training des HMM
n_it = 20;%Nombre d'iterations de l'algo EM
DIAG_COV=0;
QUIET=1;
Limits=1;for i=2:s,Limits=[Limits Limits(i-1)+Nbframes(i-1)];end; 


for i=1:NbClasses,
   
   start=sum(NbreSigTrain(1:i-1))+1;
   stop=sum(NbreSigTrain(1:i));
   Nbframesbyclass=Nbframes(start:stop);
   Limits=1;for j=2:NbreSigTrain(i),Limits=[Limits Limits(j-1)+Nbframesbyclass(j-1)];end; 
   
   featbyclass=feat(:,find(target==i))';
   %estimations val.initiales
   %A=triu(rand(N));A=A./sum(sum(A));
   if N==3,
      A=[0.25 0.5 0.25; 0 0.4 0.6; 0 0 1]; 
   elseif N==5,
   	A=zeros(N);A(1,:)=[0.4 0.3 0.2 0.05 0.05];
   	A(2,2:N)=[0.4 0.3 0.2 0.1];
   	A(3,3:N)=[0.4 0.3 0.3];
   	A(4,4:N)=[0.5 0.5];
   	A(N,N)=1;
	end;

   [mu, Sigma]=hmm_mint(featbyclass,Limits,N,DIAG_COV);
   %left-right hmm training
   [A,mu,Sigma,logl]=lrhmm(featbyclass,Limits,A,mu,Sigma,n_it);
   
   Ax(:,:,i)=full(A);
   mx(:,:,i)=mu;
   cx(:,:,i)=Sigma;
end;


