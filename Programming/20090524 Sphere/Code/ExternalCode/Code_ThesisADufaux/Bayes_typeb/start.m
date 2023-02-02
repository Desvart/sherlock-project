% ******************************************************************
% Main Start File for Sound recognition (training + testing)
% ******************************************************************

% ------------------------------------------------------------------
% Sound Recognizer Settings
% ------------------------------------------------------------------

% Clear environment
clear all;
close all;
clc;

p = path;

addpath(genpath('../reco_AD/toolboxes'));

% Location of sound classes
%Sound_Path = './sound_library/small_database';
% Sound_Path = '.\reco AD\small_database';
%Sound_Path = './sound_library/small_database';
Sound_Path = './Code_These_AD/reco_AD/small_database';
% Sound_Path = './Code_These_Pitch/tiny_database';
Sound_Path = './Code_These_AD/small_database_AD';

% Sound classes to recognize (class path + filename base)
% Class{1}='/portes/porte';
% Class{2}='/explos/explo';
% Class{3}='/chiens/chien';
% Class{4}='/verres/verre';
% Class{5}='/cris_/scream';


Class{1}='/chien/chien';
Class{2}='/explo/explo';
Class{3}='/music/music';
Class{4}='/phone/phone';
Class{5}='/porte/porte';
Class{6}='/cris/scream';
Class{7}='/verre/verre';
Class{8}='/world/world';

% Corresponding numbers of sounds to involve in each class
Sig_Nbr = [69 58 55 88 73];
Sig_Nbr = [55 58 70 51 69 73 88 41];
% Sig_Nbr = [69 58];
% Sig_Nbr = [2, 3];

% Number of features dimension after PCA reduction
PCA_dim = 10;
% PCA_dim = 0;

% Number of features dimension after LDA reduction
LDA_dim = 0;
LDA_dim = 0;

% Sound duration taken into account for analysis (in seconds)
Analysis_len = 1;

% Number of (training & testing) iterations for crossvalidation
crossvalidation_loop = 2; 

% SNR level (in dB) used at training and testing for random noise addition
SNR_training = 220;
SNR_testing = SNR_training;

% Number of classes
Class_Nbr = length(Sig_Nbr);

% Number of Signals for training and testing in each class 
% Half the signals are used for training, the other half for testing
Train_Sig_Nbr = ceil(Sig_Nbr/2);
Test_Sig_Nbr = Sig_Nbr - Train_Sig_Nbr;

% ------------------------------------------------------------------
% Initialization
% ------------------------------------------------------------------

% Initialise confusion matrix
Conf_mat = zeros(length(Sig_Nbr));

% Initialize the state of the random number generator for subsequent use
%rand('state', 0); % Default state
rand('state', round(sum(clock))); % Random state depending on clock

% Display start message
display('                                                      ');
display('******************************************************');
display('       Sound Recognition: Start Crossvalidation       ');
display('******************************************************');
display('                                                      ');

% ------------------------------------------------------------------
% Start crossvalidation loops
% ------------------------------------------------------------------

% Start loop
for i = 1:crossvalidation_loop,

    % Display current loop index
    display(['Start Iteration Nr. ', num2str(i)]);
    display('-------------------------');
   
    % Determine the indexes of the files to use for training and testing
    for j = 1:Class_Nbr, 
        indexes{j} = randperm(Sig_Nbr(j));    % Random determination
        indexes{j} = 1:Sig_Nbr(j); % No random determination
    end;

    
    % ------------------------------------------------------------------
    % Perform Training 
    % ------------------------------------------------------------------

    % Build the filename list for training
    trainfiles = []; % Clear training set
    for j = 1:Class_Nbr, 
        files{j} = filenames([Sound_Path Class{j}], indexes{j}(1:Train_Sig_Nbr(j)));
        trainfiles = [trainfiles; files{j}];  
    end;
	
    % Start Training
	[m, C, v_PCA, d_PCA, v_LDA, d_LDA, totmean, totstd] = ... 
        training(trainfiles, Train_Sig_Nbr, PCA_dim, LDA_dim, SNR_training);
    % Save trained models to file
%     save training.mat m C v_PCA d_PCA v_LDA d_LDA totmean totstd;
%     save ../../Code_These_PH/Draft-Test/trainingAD.mat m C;
    

    
    % ------------------------------------------------------------------
    % Perform Testing 
    % ------------------------------------------------------------------

    % Build the filename list for testing
    testfiles = []; % Clear testing set
    for j = 1:Class_Nbr, 
        files{j} = filenames([Sound_Path Class{j}], indexes{j}(Train_Sig_Nbr(j)+1:Sig_Nbr(j)));
        testfiles = [testfiles; files{j}];  
    end;

    % Load trained models from file
    % load training;

    % Start Testing
    [membership, cert] = testing(m, C, testfiles, Test_Sig_Nbr, ...
        v_PCA, d_PCA, v_LDA, d_LDA, PCA_dim, LDA_dim, totmean, totstd, SNR_testing);

      
    % ------------------------------------------------------------------
    % Calculate Recognition Performance
    % ------------------------------------------------------------------   
    
    % Determine Target Classification
    target = [];
    for j = 1:Class_Nbr, 
        target = [target j*ones(1,Test_Sig_Nbr(j))]; 
    end;
  
    % Calculate Confusion Matrix
    New_Conf_mat = score(membership(1:sum(Test_Sig_Nbr(1:Class_Nbr))), target(1:sum(Test_Sig_Nbr(1:Class_Nbr))));
    Conf_mat = Conf_mat + New_Conf_mat;
    res(i) = sum(diag(New_Conf_mat))/sum(sum(New_Conf_mat));
    perfo = sum(diag(Conf_mat))/sum(sum(Conf_mat));
  
    % Display Results
    display(Conf_mat);
    display(perfo);

end

path(p);
