function [feat]=features(x,fs);

%Function features: Calcule les features d'un signal x 
%de frequence d'echantillonnage fs

%************* Formation de la matrice du signal temporel ************

%Nombre de points par bloc temporel
blocsize=1024;

%Overlap
overlap=blocsize/8;

%Mise en forme matricielle
xblocs=overblocs2(x,blocsize,overlap);

%fenetrage de chaque bloc
xblocs=hann(xblocs,overlap);

% *************************** Calcul des Features ********************

%---------------------- Puissance dans chaque frame --------------------

%Puissance totale du signal dans chaque bloc
%Ptot=10*log10(sum(xblocs.^2)/blocsize);
%Ptot=Ptot/max(Ptot);

%------------------------------Spectrogramme--------------------------

%Nombre de points frequentiels sur [0 fs/2[
N=blocsize/2;

%Axe fréquentiel linéaire [0 fs/2]
f=linspace(0,fs/2,N+1);
 
%Limite des bandes spectrales
%bandes=[0:1000:20000];%uniform
bandes=[0 100 200 300 400 510 630 770 920 1080 1270 1480 1720 2000 2320 2700 3150 3700 4400 5300 6400 7700 9500 12000 15500 21000];%critical
nbandes=length(bandes)-1;

%Boucle pour chaque bande
for i=1:nbandes,
   %Index des points frequentiels par bandes spectrales
   indexb{i}=find((f>=bandes(i)) & (f<bandes(i+1)));
   %Nombre de points pour chaque bande spectrale 
   npointsb(i)=length(indexb{i});
end;

%Spectre d'amplitude bilatéral
Xb=fft(xblocs,2*N)/(2*N);		
%Spectre d'énergie bilatéral
PXb=(real(Xb)).^2 + (imag(Xb)).^2;
%Spectre d'énergie unilatéral entre [0 fs/2]
PXu=[PXb(1,:);2*PXb(2:N,:);PXb(N+1,:)];

%Puissance dans chaque bande spectrale
for i=1:nbandes,
   B(i,:)=10*log10(sum(PXu(indexb{i},:))/npointsb(i));
end;

%Puissance Max
Bmax=max(max(B));

%Normalisation
Bnorm=B-Bmax;
%Bnorm=B-repmat(Ptot,nbandes,1);
feat=[Bnorm];


%--------------------------------- LPC ---------------------------------

%order=15;
%a=lpc(xblocs,order)';
%feat=a(2:size(a,1),:);

%------------------------------- Cepstres ------------------------------

%order=50;
%c=rceps(xblocs);
%feat=c(1:order,:);

%------------------------------- MELCepstres ------------------------------
%Nombre de coefficients cepstre
%order=50;

%Parametres pour le calcul des mfcc
%mfccpar.Order = order;
%mfccpar.Delta = 0;
%mfccpar.WinSz = blocsize;
%mfccpar.StpSz = blocsize-overlap;
%mfccpar.SRate = fs;
%mfccpar.RmvSilence = 0;

%mfcc
%m = mfcc(x,mfccpar);
%feat=m.Mat';


%------------------------------- ERBfeatures ------------------------------
%decimfactor=100;
%load erb.mat;
%coch = FilterBank(forward, feedback,x);
%hc= MeddisHairCell(coch/max(max(coch))*NbChannels, fs, 1);
%for j=1:NbChannels,
%   c=hc(j,:);
%   c=filter([1],[1,-0.99],c);
%   prob(j,:)=c(1:decimfactor:length(c));
%end;
%feat=prob;

%****************************** Visualisation **************************

%subplot(2,1,1);plot(Ptot);
%subplot(2,1,2);
%surf(feat(2:nbandes+1,:));
%surf(feat);
%view(-45,45);
%set(gca,'YDir','reverse');
%axis tight;

