% ----------------------------------------------------------------------------------------
% Function : extractDatabaseInformation.m
% 
% Purpose  : This function builds the path list of the files used for training and 
%            testing. This list is generated taking into account the training strategy 
%            wanted by user.
%            Their is two major strategies : the "normal" one and the "one left" one.
%               - "normal" strategy : 
%                 This strategy split each class into two parts. The first one is used for
%                 training and the second one for testing. The ratio between this parts
%                 are defined by the choosen strategy (2 : 50% training - 50% testing, 
%                 3 : 75%-25%, 4 : 25%-75%)
%               - "one left" strategy :
%                 This strategy trains the algorithm with all the files of the database
%                 minus one. The remaning file is used for testing. Two sub-strategy are
%                 available :
%                   . 0 : the training and testing operation are done several times. The
%                         number of iteration is defined by user in the variable
%                         nbCrossvalidation
%                   . 1 : the training and testing operation are done for all possible
%                         combinaisons. This is equivalent to be in strategy one left-0
%                         with nbCrossvalidation = nbFile.
%                 From one crossvalidation to another, the testing file cannot be twice
%                 the same.
%           
% 
% Input:
%   - trainingStrategy  [scalar]
%                       This value correspond to a given strategy. See in start.m file for
%                       more details on strategies and on the correspondence.
% 
%   - nbClass           [scalar]
%                       This value is the number of class present in the database.
% 
%   - nbFile            [scalar]
%                       This value is the number of file present in all the database.
% 
%   - nbFilePerClass    [vector : nbClass x 1]
%                       Each element of this vector is the number of files present in each 
%                       class.
% 
%   - filePathPerClass  [cell : nbClass x 1]
%                       Each element of this cell contains the path of all file present in
%                       each class.
% 
%   - nbCrossvalidation [scalar]
%                       This values is the number of crossvalidation of the algorithm.
% 
% 
% Outputs:
%   - trainingFilePath  [cell : nbTrainingFile+1 x 1]
%                       This cell contains the path to all training file. The first
%                       element of this cell is like a header : it contains the number of
%                       training files used in each class.
% 
%   - testingFilePath   [cell : nbTestingFile+1 x 1]
%                       This cell contains the path to all testing file. The first
%                       element of this cell is like a header : it contains the number of
%                       testing files used in each class.
%
% 
% Author    : Pitch Corp.
% Date      : 16.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function [trainingFilePath, testingFilePath] = generateFileList(trainingStrategy, filePath)
             
    % If we are in mode "normal"
    if trainingStrategy > 1, 
        [trainingFilePath, testingFilePath] = generateNormalFileList(trainingStrategy, filePath);
                                 
        
	% If we are in mode "one left and do all crossvalidation"
    elseif trainingStrategy == 1,
        [trainingFilePath, testingFilePath] = generateOneLeftFileList(filePath, 1);

        
	% If we are in mode "one left"
    elseif trainingStrategy == 0,
        [trainingFilePath, testingFilePath] = generateOneLeftFileList(filePath);
                                       
    end
    
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ----------------------------------------------------------------------------------------
% Function : folderContents.m
% 
% Purpose  : A folder can contain sub-folders and files. This function counts the number
%            of elements (sub-folders and files) that are contained in a folder and gives 
%            their names.
%
% Inputs :  
%       folderPath  [string] 
%                   Path of the folder to analyse
%
% Outputs : 
%       nbElement   [scalar] 
%                   Number of elements found in the folder.
% 
%       elementName [cell : nbElement x 1] 
%                   Names of the elements found. Elements that names begin by the dot
%                   caracter (".") are considered as hidden files or folders and then are
%                   discarded by this function.
%
% 
% Author    : Pitch Corp.
% Date      : 16.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function [trainingFilePath, testingFilePath] = generateNormalFileList(trainingStrategy, filePath)
    
    %%% True if training file are choosen randomly.
	randomSorting = 1;
    
    %%% Extract relevant informations
    nbFilePerClass = filePath{1};
    nbClass = length(nbFilePerClass);
                                                     
    %%% Compute the number of file to use for the training and the testing parts
    switch trainingStrategy,
        
        case 2, % 50% of files are used for training and the 50% remaining for testing
            nbTrainingFilePerClass = ceil(nbFilePerClass/2);
        
        case 3, % 75% of files are used for training and the 25% remaining for testing
            nbTrainingFilePerClass = ceil(nbFilePerClass*3/4);
            
        case 4, % 25% of files are used for training and the 75% remaining for testing
            nbTrainingFilePerClass = ceil(nbFilePerClass/4);
            
        otherwise,
            error('ERROR : Unknown training strategy.');
    
    end
    nbTestingFilePerClass = nbFilePerClass - nbTrainingFilePerClass;
    nbTrainingFile = sum(nbTrainingFilePerClass);
    nbTestingFile = sum(nbTestingFilePerClass);
    
    
    
    %%% This loop generates the files index for the training and the testing parts.
    
    % Loop initialization
    cumulativNbFilePerClass = 0;
    lastTrainingIndex = 0;
    lastTestingIndex = 0;
    for i = 1 : nbClass,
        
        if randomSorting,
            randIndexForThisClass = cumulativNbFilePerClass + randperm(nbFilePerClass(i));
        else
            randIndexForThisClass = cumulativNbFilePerClass + (1:nbFilePerClass(i));
        end
        cumulativNbFilePerClass = cumulativNbFilePerClass + nbFilePerClass(i);
        
        firstTrainingIndex = lastTrainingIndex + 1;
        lastTrainingIndex = firstTrainingIndex + nbTrainingFilePerClass(i) - 1;
        
        trainingFileIndex(firstTrainingIndex:lastTrainingIndex) = randIndexForThisClass(1:nbTrainingFilePerClass(i));
                                   
        firstTestingIndex = lastTestingIndex + 1;
        lastTestingIndex = firstTestingIndex + nbTestingFilePerClass(i) - 1;
        
        testingFileIndex(firstTestingIndex:lastTestingIndex)  = randIndexForThisClass(nbTrainingFilePerClass(i)+1:end);
        
    end
                                                     

    %%% This part builds the cells containing the training and the testing files path
    %   based on the previously files index generation.
    
    trainingFilePath = cell(nbTrainingFile+1, 1);
    trainingFilePath{1} = nbTrainingFilePerClass;
    trainingFilePath(2:end) = filePath(trainingFileIndex+1);
    
    testingFilePath = cell(nbTestingFile+1, 1);
    testingFilePath{1} = nbTestingFilePerClass;
    testingFilePath(2:end) = filePath(testingFileIndex+1);

end


% ----------------------------------------------------------------------------------------
% Function : folderContents.m
% 
% Purpose  : A folder can contain sub-folders and files. This function counts the number
%            of elements (sub-folders and files) that are contained in a folder and gives 
%            their names.
%
% Inputs :  
%       folderPath  [string] 
%                   Path of the folder to analyse
%
% Outputs : 
%       nbElement   [scalar] 
%                   Number of elements found in the folder.
% 
%       elementName [cell : nbElement x 1] 
%                   Names of the elements found. Elements that names begin by the dot
%                   caracter (".") are considered as hidden files or folders and then are
%                   discarded by this function.
%
% 
% Author    : Pitch Corp.
% Date      : 16.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function [trainingFilePath, testingFilePath] = generateOneLeftFileList(filePath, allCrossvalFlag)
    
    error(nargchk(1, 2, nargin));
    if nargin == 1,
        allCrossvalFlag = 0;
    end
    
	%%% Extract relevant informations
    nbFilePerClass = filePath{1};
    nbFile  = length(filePath) - 1;
    nbClass = length(nbFilePerClass);
    
    persistent oldTestingIndex crossvalidationIndex testingFileIndex;
    
    if allCrossvalFlag == 0,
        
        if isempty(oldTestingIndex),
            oldTestingIndex = zeros(nbFile, 1);
            crossvalidationIndex = 1;
        end

        % Incr�mente la variable persistant crossvalidation index qui correspond � l'index de
        % l'actuelle crossvalidation. Un test est fait juste apr�s pour v�rifier que le nombre
        % de crossvalidation ne d�passe pas le nombre de fichiers pr�sent dans la base de
        % donn�es car cela donnerait alors des r�sultats de reconnaissance fauss�s puisque la
        % m�me reconnaissance serait faite deux fois de suite.
        % Dans le cas o� l'utilisateur voudrait faire un maximum de crossvalidation avec la
        % m�thode "one-left", il vaudrait mieux qu'il utilise la strat�gie d'entrainement 1 
        % (faire toutes les crossvalidations avec la m�thode "one-left") car la fa�on de
        % g�n�rer l'index al�atoire du fichier de test (g�n�ration sans remise) prend du temps
        % surtout si le nombre de crossvalidation d�passe 75% de la taille de la base
        % de donn�e.
        crossvalidationIndex = crossvalidationIndex + 1;
        if crossvalidationIndex-1 > nbFile,
            error('ERROR : There is more crossvalidation than number of files.');
        end

        % G�n�re un nombre al�atoire entre 1 et nbFile. Ce nombre est utilis� comme �tant
        % l'index du fichier de test. La boucle while 1 est l� pour assur� que cet index (et
        % donc le fichier qui lui est li�) n'a pas d�j� �t� utilis� lors de pr�c�dente
        % crossvalidation. La variable persistante oldTestingIndex stoque toutes les anciennes
        % valeurs d'index utilis�es pour selectionner le fichier de test. La boucle while
        % compare donc la valeur al�atoire actuelle avec celle d�j� tir�e. Tant que l'index
        % est d�j� pr�sent dans cette table, la boucle while g�n�re un nouveau nombre
        % al�atoire et recommence le test.
        while 1,
            testingFileIndex = randi(nbFile);
            if ~any(oldTestingIndex == testingFileIndex),
                oldTestingIndex(crossvalidationIndex) = testingFileIndex;
                break;
            end
        end
        
    else
        
        if isempty(testingFileIndex),
            testingFileIndex = 0;
        end

        testingFileIndex = testingFileIndex + 1;
        
    end
    
    % Constuit la cellule contenant le chemin du fichier d'entrainement. Le "header" de la
    % cellule est mis enti�rement � 0 puisque la classe d'o� vient le fichier n'est pas 
    % encore connue. La mise � jour de ce header se fera un peu plus loin dans le code.
    testingFilePath = {zeros(nbClass, 1); ...
                       filePath{testingFileIndex+1}};
    
    
    % Extrait le chemin des fichiers d'entrainement ("trainingFilePath"). Les index des 
    % fichiers d'entrainement ("trainingFileIndex") est simplement d�fini comme �tant les 
    % index de tous les fichiers ("fileIndex") de la base de donn�es auxquels on enl�ve 
    % l'index du fichier d'entrainement ("testingFileIndex").
    fileIndex = 1:nbFile;
    trainingFileIndex = fileIndex(fileIndex ~= testingFileIndex);
    trainingFilePath = cell(nbFile, 1);
    trainingFilePath(2:end) = filePath(trainingFileIndex+1);
    
    % Ce bloc de code a pour but de calculer le nombre de fichiers d'entrainement utilis�s
    % pour chaque classe. Ce nombre est identique au nombre de fichiers par classe sauf
    % pour une classe o� il sera de 1 plus petit. Il s'agit de savoir quelle est cette
    % classe. Les index des fichiers sont trait�s de mani�re absolue. Nous calculons
    % l'index relatif du fichier de test ("testingFileRelativeIndex") en soustrayant son
    % index absolu ("testingFileIndex") avec la totalit� des fichiers de chaque classe.
    % Lorsque le r�sultat de cette soustraction est plus petit que la taille de la classe 
    % en cours d'analyse, alors ce r�sultat est l'index relatif du fichier de test et il
    % appartient � la classe en cours d'analyse. On peut donc calculer sans difficult� le
    % nombre de fichiers d'entrainement pour chaque classe et stoquer le r�sultat dans le
    % header de la cellule contenant les chemins des fichiers d'entrainement.
    % Puisque la classe � laquelle appartient le fichier de test est connue, nous pouvons
    % mettre � jour le header de la cellule contenant le chemin du fichier de test. C'est
    % le code "testingFilePath{1}(i) = 1;" qui effectue cette mise � jour.
    nbTrainingFilePerClass = nbFilePerClass;
    for i = 1 : nbClass,
        testingFileRelativeIndex = testingFileIndex - sum(nbFilePerClass(1:i-1));
        if testingFileRelativeIndex <= nbFilePerClass(i),
            nbTrainingFilePerClass(i) = nbTrainingFilePerClass(i) - 1;
            testingFilePath{1}(i) = 1;
            break;
        end
    end
    trainingFilePath{1} = nbTrainingFilePerClass;

end

% --------------------------------- End of file ------------------------------------------



















