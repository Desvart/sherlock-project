function [membership,maxlogl,snr]=test(mx,cx,wx,testfiles,NbreSigTest,noiselevel)

%Cette version teste chaque frame l'une après l'autre (dans mix_post) 
%au lieu de le faire pour toutes les frames du fichier à la fois

%initialisations
s=size(testfiles,1);
NbClasses=length(NbreSigTest);
feat=[];
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
   tempfeat=features(x,fs);
   Nbframes(i)=size(tempfeat,2);
	feat=[feat tempfeat];%Calcul des features
end;

%Classification
%Calcul des probabilités a posteriori et du log likelihood pour 
%chaque classe et chaque vecteur
QUIET=1;
for j=1:size(feat,2),
   for i=1:NbClasses,
      [gamma loglikelihood(j,i)]=mix_post(feat(:,j)',wx(i,:),mx(:,:,i),cx(:,:,i),QUIET);
   end;
   framemembership(j)=find(loglikelihood(j,:)==max(loglikelihood(j,:)));
   framemaxlogl(j)=loglikelihood(j,framemembership(j));
end;

%Classification pour chaque signal
for i=1:s, 
   start=sum(Nbframes(1:i-1))+1;
   stop=sum(Nbframes(1:i));
   for j=1:NbClasses, bilan(j)=length(find(framemembership(start:stop)==j));end;
   tempmem=find(bilan==max(bilan));
   membership(i)=tempmem(1);
end;

%Rapport signal sur bruit moyen
snr=mean(snr);
