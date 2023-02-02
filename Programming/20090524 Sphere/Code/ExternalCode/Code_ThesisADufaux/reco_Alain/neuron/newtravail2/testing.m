function [membership,meancert,reject,snr]=testing(net,testfiles,NbreSigTest,v,d,vsep,dsep,M,totmean,totvar,noiselevel)

%initialisations
Msep=2;
s=size(testfiles,1);
NbClasses=length(NbreSigTest);
xfeat=[];
snr=zeros(1,s);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(testfiles(i,:));
   xlevel=10*log10(sum(x.^2)/length(x));
   noise=randn(size(x));
   noise=noiselevel*noise/max(abs(noise));
   nlevel=10*log10(sum(noise.^2)/length(noise));
   snr(i)=xlevel-nlevel;%Calcul de snr
   x=x+noise;%Ajout de bruit
   %tempfeat=mfcc(x,fs);
   tempfeat=features(x,fs);
   Nbframes(i)=size(tempfeat,2);
	xfeat=[xfeat tempfeat];%Calcul des features
end;

%Normalisation
totmean=mean(xfeat')';
normfeat=(xfeat'-repmat(totmean',size(xfeat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
xfeat=normfeat;

%Reduction PCA
%[xredfeat]=reduce(xfeat,v,d,M);
%xredfeat=xredfeat-repmat(mean(xredfeat')',1,s);%zero-mean
%Resuction LDA
%[xredfeat]=reduce(xredfeat,vsep,dsep,Msep,0);
%xfeat=xredfeat;%Mise en commentaire==> pas de réduction

%classification de chaque frame par le reseau
framecert=sim(net,xfeat);
framecert=framecert./repmat(sum(framecert),size(framecert,1),1);
fullmembership=full(compet(framecert));
for i=1:size(framecert,2), framemembership(i)=find(fullmembership(:,i)==1); end;


%Classification pour chaque signal
cert_threshold=0.10;
for i=1:s, 
   start=sum(Nbframes(1:i-1))+1;
   stop=sum(Nbframes(1:i));
   
   %Rejection des mauvaises frames
   indgoodframes=find(max(framecert(:,start:stop))>cert_threshold);
   temp=framemembership(start:stop);
   for j=1:NbClasses, bilan(j)=length(find(temp(indgoodframes)==j));end;
   %rejection
   reject(i)=0;
   if ((length(indgoodframes)/(stop-start+1))<0.5), reject(i)=1; end;
   
   %decommenter pour no rejection!
   for j=1:NbClasses, bilan(j)=length(find(framemembership(start:stop)==j));end;
   
   tempmem=find(bilan==max(bilan));
   membership(i)=tempmem(1);
	meancert(:,i)=mean((framecert(:,start:stop))')';
end;

%Rapport signal sur bruit moyen
snr=mean(snr);
