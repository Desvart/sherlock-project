function [membership,maxlogl,loglikelihood]=test(mx,cx,Ax,pio,testfiles,NbreSigTest,v,d,vsep,dsep,M,Msep,totmean,totvar,snratio,rejectflag)

%initialisations
whitening=0;
s=size(testfiles,1);
NbClasses=length(NbreSigTest)-rejectflag;
feat=[];

%bruit fichier
%noise=getwav('/pe_users/AD/sounds/sounds/sounds44/new/tunnel2.wav');
%noise=getwav('/pe_users/AD/sounds/sounds/sounds44/petitebd/musics/music001.wav');
%signal=getwav('s:\sounds\sounds\sounds44\musics\music001.wav');
%signal=getwav('c:\AD\BDaudio\newBD\musics\music001.wav');
%noise=noise/max(abs(noise));
%noise=noise-mean(noise);
%noise=noise/std(noise);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(testfiles(i,:));
   %Ajout de bruit
   %[m,ind]=max(abs(x));
   %len=min(length(x)-ind,fs/4);
   %xlevel=10*log10(sum(x(ind(1):ind(1)+len-1).^2)/len);
   xlevel=10*log10(sum(x.^2)/length(x));
   noiselevel=xlevel-snratio;
   sigmanoise=10.^(noiselevel/20);
   
   %generation de bruit blanc
   n=sigmanoise*randn(1,length(x));
   
   %generation de bruit fichier
	%noise=repmat(noise,1,ceil(length(x)/length(noise)));
	%n=sigmanoise*noise(1:length(x));

	%ajout du bruit
   x=x+n;
      %noisecreation for whitening
   if whitening~=0,
		white=sigmanoise*randn(1,length(x));
   	%whitening
		threshold=max(abs(n));
		ind=find(abs(x)<threshold);
      x(ind)=white(ind);
   end;

   
   tempfeat=features(x,fs);
   %tempfeat=meddis(x);
	%tempfeat=mfcc(x,fs);
   Nbframes(i)=size(tempfeat,2);
	feat=[feat tempfeat];%Calcul des features
end;

%Normalisation
totmean=mean(feat')';
normfeat=(feat'-repmat(totmean',size(feat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
feat=normfeat;

%Reduction PCA
[redfeat]=reduce(feat,v,d,M);
%redfeat=redfeat-repmat(mean(redfeat')',1,s);%zero-mean
%Resuction LDA
[redfeat]=reduce(redfeat,vsep,dsep,Msep,0);
feat=redfeat;%Mise en commentaire==> pas de r�duction

%Classification
%Calcul des probabilit�s a posteriori et du log likelihood pourr 
%chaque classe et chaque vecteur
QUIET=1;
for j=1:s,
   start=sum(Nbframes(1:j-1))+1;
   stop=sum(Nbframes(1:j));
   for i=1:NbClasses,
      %[alpha,beta,logscale,dens]=hmm_fb(feat(:,start:stop)',Ax(:,:,i),pio,mx(:,:,i),cx(:,:,i));
      %loglikelihood(j,i)=log(sum(alpha(length(alpha(:,1)),:)))+logscale;  
      [loglikelihood(j,i),path,plogl,dens]=hmm_vit(feat(:,start:stop)',Ax(:,:,i),pio,mx(:,:,i),cx(:,:,i));
   end;
   membership(j)=find(loglikelihood(j,:)==max(loglikelihood(j,:)));
   maxlogl(j)=loglikelihood(j,membership(j));
end;
