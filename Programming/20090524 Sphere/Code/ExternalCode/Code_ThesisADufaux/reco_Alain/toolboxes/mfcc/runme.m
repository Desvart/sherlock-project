%=========================================
% Demonstrate how to use SV_Lib commands 
%=========================================
clear all

%-----------------------------------------
% define MFCC analysis parameters
%-----------------------------------------
F_Par.Order   = 2;   % two MFCC parameters
F_Par.Delta   = 0;   % No delta-MFCC 
F_Par.WinSz   = 256; 
F_Par.StpSz   = 128;
F_Par.SRate   = 8000;
F_Par.RmvSilence = 1; % remove silence parts

%----------------------------
% calculte MFCC sequences 
%----------------------------
Sig1  = LoadNIST('yoho1.wav');
F(1) = MFCC(Sig1, F_Par);
Sig2  = LoadNIST('yoho2.wav');
F(2) = MFCC(Sig2, F_Par);

%------------------------------------
% training parameters for VQ and GMM
%------------------------------------
M_Par.Size     = 8;    
M_Par.MaxIter  = 10;
M_Par.RandSeed = 13793;

%------------------------------------
% additional parameters for HMM
%------------------------------------
M_Par.NState   = 2;   % two states          
M_Par.Conf     = [1, 1; 1, 1]; % any transion allowed

%------------------------------------
% generate codebook
%------------------------------------
Model = Gen_VQ(F, M_Par);

%------------------------------------
% plot data and codebook
%------------------------------------
hold off
plot(F(1).Mat(:, 1), F(1).Mat(:, 2), 'LineS', 'none', 'Marker', '.');
hold on
plot(F(2).Mat(:, 1), F(2).Mat(:, 2), 'LineS', 'none', 'Marker', '.');
hold on
plot(Model.Mat(:, 1), Model.Mat(:, 2), 'LineS', 'none', 'Marker', 'x', 'Color', 'r');
drawnow;

%Model = Gen_GMM(F, M_Par);
%Model = Gen_CHMM(F, M_Par);
