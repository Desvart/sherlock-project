

function [trainingFile, testingFile] = generateFileList(training, database)

    strategy = training.strategy;

	% If we are in mode "one left and do all crossvalidation"
    if strategy == 0,
        [trainingFile, testingFile] = generateOneLeftFileList(database, training.randomFlag, 1);

	% If we are in mode "one left"
    elseif strategy == 1,
        [trainingFile, testingFile] = generateOneLeftFileList(database, training.randomFlag);
        
	% If we are in mode "normal"
    elseif strategy > 0 && strategy < 1,
        [trainingFile, testingFile] = generateNormalFileList(training, database);
                                       
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

function [trainingFile, testingFile] = generateNormalFileList(training, database)
    

    %%% Extract relevant informations
    randomFlag              = training.strategy;
    nbFilePerClass          = database.nbFilePerClass;                     
    nbTrainingFilePerClass  = ceil(nbFilePerClass*training.strategy);       
    nbTestingFilePerClass   = nbFilePerClass - nbTrainingFilePerClass;
    
    
    %%% This loop generates the files index for the training and the testing parts.
    
    % Loop initialization
    cumulativNbFilePerClass = 0;
    lastTrainingIndex = 0;
    lastTestingIndex = 0;
    nbClass = database.nbClass;
    for i = 1 : nbClass,
        
        if randomFlag,
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
    
    filePath = database.filePath;
    
    trainingFile.nbFilePerClass = nbTrainingFilePerClass;
    trainingFile.nbFile         = sum(nbTrainingFilePerClass);
    trainingFile.path           = filePath(trainingFileIndex);
    trainingFile.nbClass        = nbClass;
    
    testingFile.nbFilePerClass  = nbTestingFilePerClass;
    testingFile.nbFile          = sum(nbTestingFilePerClass);
    testingFile.path            = filePath(testingFileIndex);
    testingFile.nbClass         = nbClass;

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

function [trainingFile, testingFile] = generateOneLeftFileList(database, randomFlag, allCrossvalFlag)
    
    error(nargchk(2, 3, nargin));
    if nargin == 2,
        allCrossvalFlag = 0;
    end
    
	%%% Extract relevant informations
    nbFilePerClass = database.nbFilePerClass;
    nbFile  = database.nbFile;
    nbClass = database.nbClass;
    filePath = database.filePath;
    
    persistent oldTestingIndex crossvalidationIndex testingFileIndex;
    testingFileIndex = 0;
    
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
        if randomFlag, 
            while 1,
                testingFileIndex = randi(nbFile);
                if ~any(oldTestingIndex == testingFileIndex),
                    oldTestingIndex(crossvalidationIndex) = testingFileIndex;
                    break;
                end
            end
        else
            testingFileIndex = testingFileIndex + 1;
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
    testingFile.path{1} = filePath{testingFileIndex};
    testingFile.nbFile = 1;
    
    
    
    % Extrait le chemin des fichiers d'entrainement ("trainingFilePath"). Les index des 
    % fichiers d'entrainement ("trainingFileIndex") est simplement d�fini comme �tant les 
    % index de tous les fichiers ("fileIndex") de la base de donn�es auxquels on enl�ve 
    % l'index du fichier d'entrainement ("testingFileIndex").
    fileIndex = 1:nbFile;
    trainingFileIndex = fileIndex(fileIndex ~= testingFileIndex);
    trainingFile.path = filePath(trainingFileIndex);
    trainingFile.nbFile = nbFile - 1;
    
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
    trainingFile.nbFilePerClass = nbFilePerClass;
    testingFile.nbFilePerClass = zeros(1, nbClass);
    for i = 1 : nbClass,
        testingFileRelativeIndex = testingFileIndex - sum(nbFilePerClass(1:i-1));
        if testingFileRelativeIndex <= nbFilePerClass(i),
            trainingFile.nbFilePerClass(i) = nbFilePerClass(i) - 1;
            testingFile.nbFilePerClass(i) = 1;
            break;
        end
    end
    
    
    trainingFile.nbClass = nbClass;
    testingFile.nbClass  = nbClass;
    

end

% --------------------------------- End of file ------------------------------------------



















