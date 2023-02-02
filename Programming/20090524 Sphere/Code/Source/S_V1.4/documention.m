
% 
% Structure du code
% 
% start
%       - extract data base information
%           - folder contens
% 
%       - generate file lists
%           - generate normal file list
%           - generate "one testing file" file list
% 
%       - training
%           - training Bayes
%               - feature extraction
%                   - extract signal
%                   - add noise
%                   - spectrogram extraction
%               - feature normalization
%               - feature reduction
%                   - compute PCA matrix
%                   - compute LDA matrix
%             - feature PDF modeling
% 
%       - testing 
%           - testing Bayes
%               - feature extraction (see training)
%               - feature normalization (see training)
%               - feature reduction
%                   - PCA
%                   -LDA
%               - token classification
%               - file classification
% 

%       - compute performance













%% "Documentation" des �tapes du code de reconnaissance de sons impulsifs d�velopp� pour
%% le projet Sherlock Holmes
% 
% ATTENTION : seules les �tapes clefs sont d�taill�es ici. Il y a donc de nombreux
%             morceaux de code non document�s pour le moment.
% 
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------



%% Initialisation de l'algorithme
% 
% Cette partie extrait de la base de donn�es diff�rentes informations utiles pour la
% suite. Outre ajouter dans Matlab le chemin des fonctions n�cessaires pour la bonne
% marche de l'algorithme, cette partie fait appel � la fonction suivante :
% 
% function : [nbClass, className, extensionSize, nbFile, nbFilePerClass] = ...
%                                                 extractDatabaseInformation(databasePath)
% 
% Input:
%   - databasePath      [string] 
%                       C'est le chemin d'acc�s relatif � la base de donn�e depuis le 
%                       r�pertoire o� se trouve le fichier "start.m".
% 
% 
% Outputs:
%   - nbClass           [scalar] 
%                       C'est le nombre de classes contenues dans la base de donn�es. Ce 
%                       nombre correspond au nombre de dossier pr�sent � la racine de la 
%                       base de donn�es.
% 
%   - className         [cell : nbClass x 1]
%                       Cette cellule contient le nom des classes pr�sentes dans la base
%                       de donn�es. Le nom des classes correspond aux noms des dossiers �
%                       la racine de la base de donn�es.
% 
%   - nbFile            [scalar]
%                       C'est le nombre de fichiers que contient la base de donn�es,
%                       toutes classes confondues
% 
%   - nbFilePerClass    [array : nbClass x 1]
%                       C'est le nombre de fichiers que contient chaque classe.
% 
%   - fileNamePerClass  [cell : nbClass x 1]
%                       Cette cellule contient le nom de tous les fichiers de la base de
%                       donn�es. Chaque �l�ment de la cellule contient tous les noms de 
%                       fichier de la classe correspondant � cet �l�ment.
%                       
% 
% Nested function : [nbElement, elementName] = folderContents(folderPath)
%                   Cette fonction permet de compter le nombre d'�l�ment que contient un
%                   dossier ainsi que d'en extraire les noms. 
%                   ATTENTION : - Cette fonction ne fait pas la diff�rence entre un 
%                               sous-dossier et un fichier.
%                               - Cette fonction ne tient pas compte des fichiers dont le
%                               nom commence par le caract�re "." (fichiers cach�s Linux
%                               ou MacOS).
% 
% Input:
%   - folderPath        [string]
%                       C'est le chemin relatif du dossier � analyser.
% 
% 
% Outputs:
%   - nbElement         [scalar]
%                       C'est le nombre d'�l�ment contenu dans le dossier (dossiers et 
%                       fichiers confondus).
%   - elementName       [cell : nbElements x 1]
%                       Cette cellule contient les noms des �l�ments contenus dans le
%                       dossier analys�.
% ----------------------------------------------------------------------------------------


%% Boucle de cross-validation
% 
% La boucle de crossvalidation encadre le gros de l'algorithme. La partie initiant la
% boucle contient le code initialisant la waitbar et le bouton d'annulation du script. Le 
% seul param�tre important ici est 
% 
%   - nbCrossValIndex   [scalar]
%                       C'est l'index de la crossvalidation en cours.
% 
% La partie fermant la boucle contient le code pour mettre � jour l'affichage de la
% waitbar � l'aide d'une fonction du nom de waitbarUpdate.
% 
% L'annulation du script en appuyant sur le bouton annuler de la waitbar interrompt l'
% algorithme en faisant sortir le script de la boucle. La sortie du script est donc
% "propre".
% ATTENTION : en cas d'erreur inattendu du script et d'arr�t brutal dans la boucle, la
%             waitbar ne pourra pas �tre ferm�e automatique. Il faudra le faire 
%             manuellement en tapant la commande "delete(h);". Si cela n'est pas fait � la
%             suite de l'interruption, il ne sera alors plus possible de fermer la waitbar
%             sauf en quittant Matlab!
% ----------------------------------------------------------------------------------------


%% G�n�ration des chemins d'acc�s pour les fichiers d'entrainement et de test
% 
% Cette partie permet de g�n�rer la liste des chemins d'acc�s pour les fichiers
% d'entrainement et de test. Les fichiers s�lectionn�s dependent de la strat�gie
% d'entrainement s�lectionn�e. Cette partie fait appel � une seule fonction :
% 
% function : [trainingFilePathPerClass, testingFilePathPerClass] = ...
%               generateFileList(trainingStrategy, databasePath, nbClass, className, ...
%                                    nbFilePerClass, fileNamePerClass, nbCrossvalidation);
% 
% Input:
%   - trainingFilePathPerClass  [cell : nbClass x 1] 
%                       Chaque cellule contient la liste des chemins des fichiers
%                       d'entrainement pour une classe donn�e.
% 
%   - testingFilePathPerClass   [cell : nbClass x 1] 
%                       Chaque cellule contient la liste des chemins des fichiers de test 
%                       pour une classe donn�e.
% 
% 
% Outputs:
%   - trainingStrategy  [scalar] 
%                       C'est le nombre de classes contenues dans la base de donn�es. Ce 
%                       nombre correspond au nombre de dossier pr�sent � la racine de la 
%                       base de donn�es.
% 
%   - databasePath      []
% 
%   - nbClass
% 
%   - className
% 
%   - nbFilePerClass
% 
%   - fileNamePerClass
% 
%   - nbCrossvalidation
% 
% ----------------------------------------------------------------------------------------


%% Fin du script
% 
% La fin du script contient uniquement deux �tapes :
%   - suppression de la waitbar
%   - suppression du chemin du toolbox
% ----------------------------------------------------------------------------------------


% --------------------------------- End of file ------------------------------------------
