function [net,v,d,vsep,dsep,totmean,totvar,snr]=training(trainfiles,NbreSigTrain,M,noiselevel)

%initialisations
Msep=2;
s=size(trainfiles,1);
feat=[];
target=[];
NbClasses=length(NbreSigTrain);
snr=zeros(1,s);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(trainfiles(i,:));
   xlevel=10*log10(sum(x.^2)/length(x));
   noise=randn(size(x));
   noise=noiselevel*noise/max(abs(noise));
   nlevel=10*log10(sum(noise.^2)/length(noise));
   snr(i)=xlevel-nlevel;%Calcul de snr
   x=x+noise;%Ajout de bruit
   %tempfeat=mfcc(x,fs);
   tempfeat=features(x,fs);
   Nbframes(i)=size(tempfeat,2);
	feat=[feat tempfeat];%Calcul des features
end;

%Normalisation
totmean=mean(feat')';
normfeat=(feat'-repmat(totmean',size(feat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
feat=normfeat;

%target
for j=1:NbClasses, 
   start=sum(NbreSigTrain(1:j-1))+1;
   stop=sum(NbreSigTrain(1:j));
   target=[target j*ones(1,sum(Nbframes(start:stop)))]; 
end;

%Reduction PCA
[v,d]=coveig(feat);
%[redfeat]=reduce(feat,v,d,M);%unit variance
%redfeat=redfeat-repmat(mean(redfeat')',1,s);%zero-mean

%Reduction LDA
vsep=[];dsep=[];
%[vsep,dsep]=separability(redfeat,target,NbClasses);
%[redfeat]=reduce(redfeat,vsep,dsep,Msep,0);
%feat=redfeat;%Mise en commentaire==> pas de réduction

%Parametres du reseau
%2couches
%S1=30;%Nombre de Neurones dans la couche cachee
%S2=NbClasses;%Nombre de Neurones dans la couche de sortie
%net = newff(minmax(feat),[S1 S2],{'logsig' 'logsig'},'traingdx');
%3couches
S1=10;%Nombre de Neurones dans la couche cachee 1
S2 = 30; %Nombre de Neurones dans la couche cachee 2
S3=NbClasses; %Nombre de Neurones dans la couche de sortie
net = newff(minmax(feat),[S1 S2 S3],{'logsig' 'logsig' 'logsig' },'traingdx');

net.LW{2,1} = net.LW{2,1}*0.01;
net.b{2} = net.b{2}*0.01;
net.performFcn = 'mse';        % Mean-Squared Error performance function
net.trainParam.goal = 0.08;    % Mean-squared error goal.
net.trainParam.show = 50;      % Frequency of progress displays (in epochs).
net.trainParam.epochs = 10000;  % Maximum number of epochs to train.
net.trainParam.mc = 0.95;      % Momentum constant.

%Calcul de la matrice de Targets (pour train)
target=[];
for j=1:NbClasses,
   start=sum(NbreSigTrain(1:j-1))+1;
   stop=sum(NbreSigTrain(1:j));
   newtarget=zeros(NbClasses,sum(Nbframes(start:stop)));
   newtarget(j,:)=ones(1,sum(Nbframes(start:stop)));
   target=[target newtarget];
end;

%Train
net=train(net,feat,target);

%Rapport signal sur bruit moyen
snr=mean(snr);

