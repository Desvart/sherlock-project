function output = config_(varargin) 
% CONFIG_	This is the configuration structure for Sphere project. This structure contains all
%           values that user can modify to control recognition process.
%
% Synopsis:     config_()
%               config_(input1)
%               config_(input1, input2)
%
% Inputs:   input1  = (optional) This is a string that indicate wich structure field is selected by
%                     the function. String should have the same name as structure fields. If only
%                     this configeter is define, then output function is the value in the field
%                     defined by input1. Function is "get mode".
%                     Ex.: libraryPath = config('libraryPath');
%           input2  = (optional) If a second input is present, the value of input2 will replace the
%                     field defined by input1. Function is a "set mode".
%                     Ex.: config('isRealData', false);
%
% Output:   output  = Strongly depend on how many input are present.
%                     No input : output gives the entire config structure.
%                     1 input  : output gives the values store in the field designated by the input.
%                     2 inputs : There is no output available.

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    persistent config 
    if isempty(config), % Default values
        
        % --- General Input/Output configuration
        config.isVerbose               	= true;     % If true, verbose mode is on (= debug mode). This will display additional information during execution process.
        config.shouldSaveConfig       	= true;     % If true, save config structure in an m file in the output folder.
        config.shouldSaveLogging       	= false;    % If true, save logging data in a text file in the output folder.
        config.shouldCleanOutputFolder 	= true;     % If true, previous logging text file are deleted before saving a new one.
        config.shouldAskForConfirmation	= false;    % If true, previous logging text file are deleted before saving a new one.
        config.shouldCheckUserInput     = true;     % If true, all inputs are checked to be valid and coherent.
        config.shouldLoadConfig        	= false;    % If true, loads previsoulsy saved config located at config.savedConfigPath address.
        config.savedConfigPath          = './Output/20110803_114928_savedConfig.mat'; % Path where is store a config to load.
        
        
        % --- Generic path definition
        config.libPath          = './Library/'; % Relative root path of Library folder
        config.databaseRootPath = '../../Database/';      % Relative root path of Database folder
        config.outputPath       = './Output/';  % Relative root path of Output folder
        
        
        % --- Database configuration
        config.databaseName = 'db_Duf_2C_XSmall'; % 
%         config.databaseName = 'db_Duf_8C'; % 
%         config.databaseName = ''; % 
        config.trainingSnr  = 120;        % (dB)
        config.testingSnr   = 120;        % (dB)

        
        % --- Configuration used to created features based on GMM.
%         config.classMean        = [0 9 18];
%         config.classCov(:,:,1)  = 1;
%         config.classCov(:,:,2)  = 1;
%         config.classCov(:,:,3)  = 1;
%         config.classMean        = [[0 0]' [9 0]' [0 9]'];
%         config.classCov(:,:,1)  = eye(2);
%         config.classCov(:,:,2)  = eye(2);
%         config.classCov(:,:,3)  = eye(2);
        config.classMean        = [[0 0 0]' [9 0 0]' [0 0 9]'];
        config.classCov(:,:,1)  = eye(3);
        config.classCov(:,:,2)  = eye(3);
        config.classCov(:,:,3)  = eye(3);
%         config.classMean        = [[0 0 0 0]' [9 0 0 0]' [0 0 9 5]'];
%         config.classCov(:,:,1)  = eye(4);
%         config.classCov(:,:,2)  = eye(4);
%         config.classCov(:,:,3)  = eye(4);
%         config.classCov(4,4,3)  = 5;
        config.nFilePerClass    = [20 30 10];
        config.nFeaturePerFile  = 50;
        
        
        % Feature extraction configuration ------------------------------------------------------- %
        % --- Those configeters are used when a database path exists. They are used to extract
        % featres from signals existing in the database.
        
        config.extractionType       = 'stdft';% Short Time Discrete Fourier Transform
        config.shouldCompactFeature = false; % Type M
        
        config.stdftWindow         	= sqrt(hann(1024, 'periodic')); % Window for windowing each STDFT blocks
        config.stdftShift           = 1/4;                          % Shift between each STDFT blocks (%)
        config.stdftPowerThreshold  = 25;                           % Power threshold below wich STDFT blocks are disscarded (dB) (0 dB means "no discard");
        config.stdftChannelName     = 'Bark';     % Channel limits to reduce frequency bands by regrouping them (Hz) ('' means no channel)
        
        % --- Reduction configuration
        config.nDimPca = 10;
        config.nDimLda = 5;
                
        
        % Learning configuration ----------------------------------------------------------------- %
        %   1  : training over all minus 1 files, testing over the last file
        %   0  : same as strategy 1 but this time all the crossvalidation are done
        % 0<x<1: training over x% of the database and testing over the (1-x)% remaining
        config.nTraining         = 10;
        config.learningStrategy  = 0.5;
        config.isRandom          = false;

        
        % Model configuration -------------------------------------------------------------------- %
        config.modelType = 'gmm';
        
        % --- GMM model configuration
        config.gmmNGmm               = 1;
        config.gmmEmTolerance        = 1e-6;

        % --- HMM model configuration
        config.hmmNState             = 3;
        config.hmmNGmm               = 1;
        config.hmmEmTolerance        = 1e-6;
        % ---------------------------------------------------------------------------------------- %

    end % if isempty(config),
    
    
    
    switch nargin,
        
        % --- Get functions
        case 0,                             % Get entire structure
            if nargout == 1,
                output = config; 
                
            elseif nargout == 0
                if config.shouldLoadConfig,
                    config_('load', config.savedConfigPath);
                    
                end
            end
            
        case 1,                             % Get requested field        
            output = config.(varargin{1}); 
    
        % --- Set functions
        case 2,
            
            switch varargin{1},
                
                case 'load',                % Set the entire structure
                    fprintf('Ongoing process: loading config...\n');
                    if strcmp(varargin{2}, ''),
                        varargin{2} = config.savedConfigPath;
                    end
                    if ~exist(varargin{2}, 'file'),
                        error('ERROR while loading config : ''%s'' file does not exist.\n\n', varargin{2});
                    end    
                    load(varargin{2});
                    config = savedConfig; %#ok<NODEF>
                    fprintf('Config successfully loaded : %s\n\n', varargin{2});
                    
                case 'save',                % Export entire structure into mat-file
                    fprintf('Ongoing process: saving config...\n');
                    if strcmp(varargin{2}, ''),
                        varargin{2} = now_string();
                    end
                    filePath = [config.outputPath, varargin{2}, '_savedConfig.mat'];
                    savedConfig = config; %#ok<NASGU>
                    save(filePath, 'savedConfig');
                    fprintf('Config successfully saved : %s\n\n', filePath);
                    
                otherwise                   % Set requested field
                    config.(varargin{1}) = varargin{2};
            end
        
        otherwise,
            error('There is too many inputs arguments in ''config'' function.');
    end
    
end %%% Enf of main function


% EoF -------------------------------------------------------------------------------------------- %
