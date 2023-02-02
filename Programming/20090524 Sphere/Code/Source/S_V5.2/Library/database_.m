function output = database_(varargin) 
% DATABASE_	
%
% Synopsis:              database_();
%               output = database_();
%                        database_(input1);
%                        database_(input1, input2);
%
% Inputs:   input1  = (optional) This is a string that indicate wich structure field is selected by
%                     the function. String should have the same name as structure fields. If only
%                     this featureeter is define, then output function is the value in the field
%                     defined by input1. Function is "get mode".
%                     Ex.: libraryPath = config('libraryPath');
%           input2  = (optional) If a second input is present, the value of input2 will replace the
%                     field defined by input1. Function is a "set mode".
%                     Ex.: config('isRealData', false);
%
% Output:   output  = Strongly depend on how many input are present.
%                     No input : output gives the entire structure.
%                     1 input  : output gives the values store in the field designated by the input.
%                     2 inputs : There is no output available.

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    persistent database
    if isempty(database), % Default values
        
        database.databasePath     = [config_('databaseRootPath'), config_('databaseName')];
        database.filePathPerClass = {''};
        
        database.nClass           = 0;    % number of class in database
        database.className        = {''};
        
        database.nFile            = 0;    % number of file in all database
        database.fileLabel        = {''}; % file labels
        database.nFilePerClass    = 0;    % number of file per class
        
        database.nTrainingFile    = 0;
        database.nTrainingFilePerClass = 0;
        database.trainingSetId    = {''}; % Cell(iTrainingId, iClass)
        
        database.nTestingFile     = 0;
        database.nTestingFilePerClass = 0;
        database.testingSetId     = {''}; % Cell(iTrainingId, iClass)

    end
    
    
    
    switch nargin,
        
        % --- Get functions
        case 0,                             % Get entire structure
            if nargout == 1,
                output = database; 
                
            elseif nargout == 0
                extact_database_statistic();
                
            end
                
        case 1,                             % Get requested field        
            output = database.(varargin{1}); 
    
        % --- Set functions
        case 2,
            if strcmp(varargin{1}, 'load'), % Set the entire structure
                if ischar(varargin{2}),
                    load(varargin{2});
                    database = savedfeature;
                    
                elseif isstruct(varargin{2}),
                    database = varargin{2};
                    
                end
                
            else                            % Set requested field
                database.(varargin{1}) = varargin{2};
            end
        
        otherwise,
            error('There is too many inputs arguments in ''feature'' function.');
    end
    
end




function extact_database_statistic()
% EXTACT_DATABASE_STATISTIC
%
% Synopsis: extact_database_statistic();
%
% Inputs  : -
% Outputs : -

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    % --- 
    if ~isempty(config_('databaseName')),
        if ~exist(database_('databasePath'), 'dir'),
            error('ERROR while loading database : ''%s'' flder does not exist.\n\n', database_('databasePath'));
        end 
        db.databasePath = database_('databasePath');

        %%% Extact the number of class and their names
        [db.nClass, db.className] = extract_folder_inventory(db.databasePath); 

        %%% Extract number of files per class and build each class path
        db.nFilePerClass    = zeros(1, db.nClass); % Preallocation
        db.filePathPerClass = cell(db.nClass, 1);  % Preallocation
        for iClass = 1:db.nClass, 
            classPathForThisClass = [db.databasePath, '/', db.className{iClass}, '/'];
            [db.nFilePerClass(iClass), fileName] = extract_folder_inventory(classPathForThisClass);

            classPathArray = classPathForThisClass(ones(db.nFilePerClass(iClass), 1), :); % Duplicate string
            db.filePathPerClass{iClass} = strcat(classPathArray, fileName);
            
        end

        %%% Compute total number of files
        db.nFile = sum(db.nFilePerClass);

        %%% Concatenate all file path to obtain one cell with all file path and determine file real label
        db.filePath  = cell(db.nFile, 1);
        db.fileLabel = zeros(1, db.nFile);
        stop = 0;
        for iClass = 1:db.nClass,
            start = stop  + 1;
            stop  = start + db.nFilePerClass(iClass) - 1;
            db.filePath(start:stop) = db.filePathPerClass{iClass};
            db.fileLabel(start:stop) = iClass(ones(1, db.nFilePerClass(iClass)));
        end

	% --- 
    else
        db.databasePath = '';
        db.filePath  = {''};
        
        %%% Extact the number of class and their names
        db.nClass = size(config_('classMean'), 2);
        
        %%% Generate class names
        db.className = cell(1, db.nClass); % Preallocation
        for iClass = 1:db.nClass,
            db.className{iClass} = ['Class ', num2str(iClass)];
        end
        
        %%% Extract number of files per class and build each class path
        db.nFilePerClass = config_('nFilePerClass');
        db.filePathPerClass = '';
        
        %%% Compute total number of files
        db.nFile = sum(db.nFilePerClass);

        %%% Concatenate all file path to obtain one cell with all file path and determine file real label
        db.fileLabel = zeros(1, db.nFile); % Preallocation
        stop = 0; % Loop init
        for iClass = 1 : db.nClass,
            start = stop + 1;
            stop = start + db.nFilePerClass(iClass) - 1;
            db.fileLabel(start:stop) = iClass;
            
        end   
    end
    
    
    % --- Compute number of training and testing file per class
    learningStrategy = config_('learningStrategy');
    if learningStrategy,
        db.nTrainingFile = min(ceil(learningStrategy * db.nFile), db.nFile-1); % min = 1; max = nFile-1
        db.nTestingFile  = db.nFile - db.nTrainingFile;
        
        if db.nTestingFile ~= 1,
            db.nTrainingFilePerClass = min(ceil(learningStrategy * db.nFilePerClass), db.nFilePerClass - 1); % min = 1; max = nFile-1
            db.nTestingFilePerClass  = db.nFilePerClass - db.nTrainingFilePerClass;
            
            % Due to ceil function (2 lines above) we recompute nTrainingFile to avoid potential
            % troncating errors.
            db.nTrainingFile = sum(db.nTrainingFilePerClass);
            db.nTestingFile  = sum(db.nTestingFilePerClass);
            
        end
    else
        db.nTrainingFile = db.nFile - 1;
        db.nTestingFile  = 1;
        config_('nTraining', db.nFile);
        db.nTrainingFilePerClass = 0;
        db.nTestingFilePerClass  = 0;

    end
    
    
    
    % --- Load the computed value in the database_ structure
    db.trainingSetId = {''};
	db.testingSetId  = {''};
    database_('load', db);

end

% EoF -------------------------------------------------------------------------------------------- %
