% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This script initialize Matlab workspace. All Matlab windows are closed and the Command Window is 
% cleared. All paths needed for the program execution are added to the "Matlab search path". Finally
% the program header is displayed in the Command Window. This script also load all user parameters.
%
%
% Author    : Pitch Corp.
% Date      : 2010.12.11
% Version   : 0.4.2
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

% ------------------------------------------------------------------------------------------------ %
% Clear workspace
% ------------------------------------------------------------------------------------------------ %

clear all;
close all;
clc;


% ------------------------------------------------------------------------------------------------ %
% Database selection
% ------------------------------------------------------------------------------------------------ %

dbPath = 3; % dim
% dbPath = '../../database/db_Duf_5C/';
% dbPath = '../../database/db_Duf_2C_Small/';


% ------------------------------------------------------------------------------------------------ %
% Add noise to signal (snr(1) = training noise, snr(2) = testing noise)
% ------------------------------------------------------------------------------------------------ %

snr(1) = 120;    %dB
snr(2) = 120;%snr(1); %dB


% ------------------------------------------------------------------------------------------------ %
% Feature to extract
% ------------------------------------------------------------------------------------------------ %

% spectrogram
featExtractParam = [1,2048,1/2]; % [Feature type, Window size, shift, file2plot];
% MFCC
% featExtractParam = [2,?]; % [Feature type, ?];

% file features to plot
% file2plot = {1:2,1:2,1:2};
file2plot = true;


% ------------------------------------------------------------------------------------------------ %
% Learning parameter definition
% ------------------------------------------------------------------------------------------------ %

%  1  : training over all minus 1 files, testing over the last file
%  0  : same as strategy 1 but this time all the crossvalidation are done
%0<x<1: training over x% of the database and testing over the (1-x)% remaining
learningParam = [0.1,false,2]; % [learning strategy, random flag, #crossvalidation]

% Feature reduction
reductionParam = [10,5]; % [PCA remaining dimension, LDA remaining dimension] - LDA NOT IMPLEMENTED


% ------------------------------------------------------------------------------------------------ %
% Probability Density Function (PDF) model
% ------------------------------------------------------------------------------------------------ %

% Bayes
model = 1;
% GMM
% model = [2,3,1e-6]; % [model type, #GMM, EM tolerance]


% ------------------------------------------------------------------------------------------------ %
% Display program header
% ------------------------------------------------------------------------------------------------ %

display('                                                                                    ');
display('% -------------------------------------------------------------------------------- %');
display('                           SOUND RECOGNITION TOOLBOX                                ');
display('                                                                                    ');
display('% -------------------------------------------------------------------------------- %');
display('                                                                                    ');


% ------------------------------------------------------------------------------------------------ %
% Add library path to "Matlab search path"
% ------------------------------------------------------------------------------------------------ %

libPath = './Lib/';
addpath(genpath(libPath));

% EoF -------------------------------------------------------------------------------------------- %
