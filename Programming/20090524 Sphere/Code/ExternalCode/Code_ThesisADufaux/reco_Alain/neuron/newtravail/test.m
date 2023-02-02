function [membership,output,snr]=testing(net,testfiles,NbreSigTest,v,d,vsep,dsep,M,totmean,totvar,noiselevel)

%initialisations
Msep=2;
s=size(testfiles,1);
xfeat=[];
snr=zeros(1,s);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(testfiles(i,:));
   l=length(x); if l<fs; lsup=fs-l;x=[x x(l-lsup:l)];end;
   xlevel=10*log10(sum(x.^2)/length(x));
   noise=randn(size(x));
   noise=noiselevel*noise/max(abs(noise));
   nlevel=10*log10(sum(noise.^2)/length(noise));
   snr(i)=xlevel-nlevel;%Calcul de snr
   x=x+noise;%Ajout de bruit
	xfeat=[xfeat features(x(1:fs),fs)];%Calcul des features
end;

%Normalisation
totmean=mean(xfeat')';
normfeat=(xfeat'-repmat(totmean',size(xfeat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
xfeat=normfeat;

%Reduction
[xredfeat]=reduce(xfeat,v,d,M);
%xredfeat=xredfeat-repmat(mean(xredfeat')',1,s);%zero-mean

%Resuction LDA
[xredfeat]=reduce(xredfeat,vsep,dsep,Msep,0);
xfeat=xredfeat;%Mise en commentaire==> pas de réduction

%classification par le reseau
output=sim(net,xfeat);
fullmembership=full(compet(output));
for i=1:s, membership(i)=find(fullmembership(:,i)==1); end;

%Rapport signal sur bruit moyen
snr=mean(snr);
