function [membership,cert]=testing(net,testfiles,NbreSigTest,v,d,vsep,dsep,M,Msep,totmean,totvar,snratio)

%initialisations
whitening=0;
s=size(testfiles,1);
feat=[];

%bruit fichier
%noise=getwav('/pe_users/AD/sounds/sounds/sounds44/new/tunnel2.wav');
noise=getwav('s:/sounds/sounds/sounds44/new/tunnel2.wav');
noise=noise/max(abs(noise));
noise=noise-mean(noise);
noise=noise/std(noise);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(testfiles(i,:));
   %l=length(x); if l<fs; lsup=fs-l;x=[x x(l-lsup:l)];end;
   
   %Ajout de bruit
   %[m,ind]=max(abs(x));
   %len=min(length(x)-ind,fs/4);
   %xlevel=10*log10(sum(x(ind(1):ind(1)+len-1).^2)/len);
   xlevel=10*log10(sum(x.^2)/length(x));

   %generation de bruit blanc
   noiselevel=xlevel-snratio;
   sigmanoise=10.^(noiselevel/20);
   n=sigmanoise*randn(1,length(x));
   
   %generation de bruit fichier
	%noise=repmat(noise,1,floor(length(x)/length(noise)));
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

   
   tempfeat=features(x(1:fs),fs);
   %tempfeat=meddis(x(1:fs));
	%tempfeat=mfcc(x(1:fs),fs);
	feat=[feat tempfeat];%Calcul des features
end;

%Normalisation
totmean=mean(feat')';
normfeat=(feat'-repmat(totmean',size(feat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
feat=normfeat;

%Reduction
[redfeat]=reduce(feat,v,d,M);
%xredfeat=xredfeat-repmat(mean(xredfeat')',1,s);%zero-mean
%Reduction LDA
[redfeat]=reduce(redfeat,vsep,dsep,Msep,0);
feat=redfeat;%Mise en commentaire==> pas de r�duction

%classification par le reseau
output=sim(net,feat);
cert=output./repmat(sum(output),size(output,1),1);
fullmembership=full(compet(output));
for i=1:s, membership(i)=find(fullmembership(:,i)==1); end;

