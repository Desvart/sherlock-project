% Sherlock Holmes - Tagging script
% ShH - TaSc
%
% But du script : 
% Le but de ce script est de g�n�rer une interface d'aide pour le marquage des signaux ViSo.
% L'interface est compos�e d'une figure o� est affich�, en bas, l'int�gralit� du signal ViSo et dans
% la partie principale de la figure un zoom du toc en cours d'analyse. Ce dernier est signal� dans
% le signal int�grale (en bas) par un carr� rouge qui l'entoure. La d�tection grossi�re des tocs est
% r�alis�e � l'aide de l'algorithme shh_pandas_B10 (param : 41, 15, 1600). Ce script n�cessite deux
% �crans de taille similaire pour �tre fonctionnel et �tre exploit�.
% 
% Protocole d'utilisation :
% L'utilisateur r�gle les param�tres du script en fonction de ses besoins et sp�cifie le chemin
% complet du fichier ViSo � marquer. L'ex�cution du script charge le signal dans une fen�tre double
% �cran. Si les r�glages des param�tres PANDAS sont corrects, le d�but de chaque toc aura �t�
% correctement d�tect�. Ils apparaissent comme des �toiles rouges sur le signal du bas. Si un toc
% poss�de plus d'une �toile ou que sont unique �toile est mal plac�e, c'est que les param�tres
% shh_pandas_B10 ne sont pas adapt�s � ce signal ou que ce dernier est hors du domaine traitable par
% shh_pandas_B10. L'utilisateur peut dans le zoom marquer le signal � l'aide de "Data Cursor"
% Matlab. S'il souhaite marquer plus d'un �l�ment dans le zoom, il peut le faire en d�posant plus
% d'un "Data Cursor" � la fois � l'aide de la touche ALT (maintenir ALT enfonc� en cliquer sur le
% nouvel �chantillon � marquer). Lorsque tous les marquages d�sir�s ont �t� positionn�,
% l'utilisateur peut passer au toc suivant. Pour celui, il doit rendre la fen�tre de commande Matlab
% active (en cliquant dedans par exemple) puis presser sur n'importe quelle touche du clavier. La
% position en abscisse des �chantillons marqu�s apparait alors sous forme de tableau. L'utilisateur
% peut alors marquer le toc suivant. Au bout du nombre de tocs d�finis par l'utilisateur, le script
% prend fin et affiche l'ensemble des marquages r�alis�s. Si l'utilisateur a sp�cifi� un facteur de
% correction de l'axe des abscisses (i.e. : correction de la base de temps), l'affichage final sera
% r�alis� avec ce facteur de correction.
% Dans le cas o� l'utilisateur souhaite ajouter un certain nombre d'informations par toc (des
% marquages pr�c�dents ou des "flags") � la suite des marquages qu'il vient de r�aliser, cela est
% possible � condition de cr�er, dans l'espace de travail une variable nomm�e "moreTag" qui est un
% tableau contenant toutes les valeurs � ajouter � chaque toc (une ligne par toc et une colonne par
% valeur suppl�mentaire). Cette variable doit �tre cr��e avant (!) l'ex�cution du script.
%
% Remarques diverses : 
% - Aucune s�curit� n'a �t� mise en place concernant la validit� des param�tres sp�cifi�s par
% l'utilisateur.
% - Vu qu'il est ais� de se tromper lors des sessions de marquage, une petite s�curit� a �t� mise en
% place qui permet de v�rifier le nombre de marquage par toc. Si celui-ci est diff�rent de la valeur
% impos�e dans les param�tres du script, un avertissement sera affich� dans la fen�tre de commandes
% et l'utilisateur devra supprimer les marquages en trop ou rajouter ceux manquant.
% 
% Script parameters :
% TIME_BASE_CORRECTION_FACTOR   Factor to adapt tag time base. This allows to plot signal in a time
%                               base (the camera time base for example) and to save tags in another 
%                               time base (signal time base). 
%                               Default value : 0.99471
% PANDAS_WIN_SIZE               shh_pandas_B10 parameters (see pandas_ doc).
%                               Default value : 41
% PANDAS_STD_THRESHOLD          shh_pandas_B10 parameters (see pandas_ doc).
%                               Default value : 15
% PANDAS_DIST_THRESHOLD         shh_pandas_B10 parameters (see pandas_ doc).
%                               Default value : 1600
% FIGURE_BORDER_SIZE            Border size of a figure in pixels. It is the difference between the 
%                               figure size and the useful space (also named workspace size). This 
%                               value is OS dependent.
%                               Default value : [8, 8, 80, 8]; [Left, Right, Top, Bottom]
% FIGURE_LOCATION_OFFSET        Offset in pixel used to see a piece of Matlab command windows when 
%                               main figure is displayed.
%                               Default value : [0, 42]; [Left, Bottom]
% MAIN_AXES_POSITION            Position (location and size) of the main axe that contains all ViSo
%                               signal (values are relative).
%                               Default value : [2.5, 3.5, 97, 96]/100; [Left, Bottom, Width, Heigh]
% ZOOM_AXE_RELATIVE_POSITION    Relative position (location and size) of zoom axe relative to
%                               figure position.
%                               Default value : [4, 15, 95, 80]/100;    [Left, Bottom, Width, Heigh]
% Y_LIM                         Limit of the main display in vertical axis.
%                               Default value : [-0.01, 5.5]
% N_TOC                         Number of tocs to tag.
%                               Default value : 12
% N_TAG_PER_TOC                 Number of tags to be expected per tocs.
%                               Default value : 8
% N_DIGIT                       Number of digit below 0 to use to display tags.
%                               Default value : 6
% TOC_WIDTH                     Toc width in seconds.
%                               Default value : 20e-3
% PROJECT_PATH                  Project path
% DATABASE_RPATH                Database relative path (relative to project path)
% FILE_FNAME                    Full file Name (name + extension)
% START_TOC_ID                  Identifier of first toc to tag
%                               Default value : 1
%
% See also shh_pandas

% Project : Sherlock Holmes (ShH) - Tagging Script (TaSc) (Beta 1.0)
% 2013.01.08 - 2013.01.21
%
% � 2012-2015 Pitch Corp.
%   Author  : Pitch

% Log
% 2013.01.21    Script operational (Beta 1.0 = A0.2.4)
%               - Script parameters fine tuning
%               - Write comments
% 2013.01.18    Tweak script parameters (A0.2.3)
% 2013.01.15    Add PANDAS to Tagging Script to enhanced toc detection (A0.2.0)
% 2013.01.08	File creation (Alpha 0.0.0).


% To do (or could be done)
% - Add a keyboard command in main figure to switch toc without going back to Matlab command
%   windows.
% - Write header comments in english.
% - Find a way to add moreTag values more "properly" than forcing user to add them into workspace
%   before lauching Tagging Script.
% - Add a security layer to check user inputs validity
% - Add a security layer to check monitor configuration (double screen, screen size, workspace size,
%   etc.)
% - Add a check box for each tag to describe the tag nature (for exemple selected from a preloaded
%   list box containing all possible tag nature). This way of doing the tagging allow user to have
%   different number of tags per toc.

% To fix
% -


%% Clean Matlab environment

close all;                  % Close all figure
% save('tmp.mat', 'moreTag'); % Save moreTag value before erasing all workspace values
clear all;                  % Clear all variables
clc;                        % Clear command windows


%% Script parameters

DEV_FLAG                          = true;

TIME_BASE_CORRECTION_FACTOR       = 0.99471;        % - (ratio)
PANDAS_WIN_SIZE                   = 41;             % Samples
PANDAS_STD_THRESHOLD              = 15;             % - (ratio)
PANDAS_DIST_THRESHOLD             = 1600;           % Samples
FIGURE_BORDER_SIZE                = [8, 8, 80, 8];  % [Left, Right, Top, Bottom] pxl
FIGURE_LOCATION_OFFSET            = [0, 42];        % [Left, Bottom] pxl
MAIN_AXE_POSITION                 = [0.025, 0.035, 0.97, 0.96]; % [Left, Bottom, Width, Heigh] Norm.
ZOOM_AXE_RELATIVE_POSITION        = [0.04,  0.15,  0.95, 0.80]; % [Left, Bottom, Width, Heigh] Norm.
Y_LIM                             = [-0.01, 5.5];   % [min, max] norm (max value : 1)
N_TOC                             = 12;             %
N_TAG_PER_TOC                     = 8;              % Default = 8
N_DIGIT                           = 6;              % tRes = 3e.6; @ fs = 20 kS/s
TOC_WIDTH                         = 20e-3;          % seconds
PROJECT_PATH                      = '.\\Ongoing\Sherlock Holmes ABP011\';
DATABASE_RPATH                    = 'Data\Videos\ViSo\ViSo_2_0\ML_Influence_du_barillet\';
FILE_FNAME                        = 'ML0156-03c_R00_B06_N01.mat';
START_TOC_ID                      = 1;              %


%% Init

% DEV ONLY - Load local dependencies
if DEV_FLAG, addpath('..\Dependencies\'); end

% Load signal
load([PROJECT_PATH, DATABASE_RPATH, FILE_FNAME]);

% Compute signal magnitude and time axis
signal = abs(signal);                           % Signal magnitude
tAxis = (0:length(signal)-1)/fs;                % Signal time axis
tAxis = tAxis ./ TIME_BASE_CORRECTION_FACTOR;

% Detect d�gagement start
tocStartIdxArray = shh_pandas(signal, PANDAS_WIN_SIZE, PANDAS_STD_THRESHOLD, PANDAS_DIST_THRESHOLD);


%%% Compute figure position

% Compute figure location
figureLocationCorrectionFactor = FIGURE_BORDER_SIZE(1, 4);                % [Left, Bottom] pxl
figureLocation = FIGURE_LOCATION_OFFSET + figureLocationCorrectionFactor; % [Left, Bottom] pxl

% Extract screen size
screenPosition = get(0, 'ScreenSize'); % pxl
screenSize     = screenPosition(3:4);  % pxl
dblScreenSize  = screenSize .* [2, 1]; % Hypothesis : same size double screens (pxl)

% Compute figure size
figureSizeWidthCorrectionFactor = sum(FIGURE_BORDER_SIZE(1:2)) + FIGURE_LOCATION_OFFSET(1);
figureSizeHeighCorrectionFactor = sum(FIGURE_BORDER_SIZE(3:4)) + FIGURE_LOCATION_OFFSET(2);
figureSizeCorrectionFactor     = [figureSizeWidthCorrectionFactor, figureSizeHeighCorrectionFactor];
figureSize                     = dblScreenSize - figureSizeCorrectionFactor; % [Width, Heigh] pxl


% Build figure and main axe
hFig = figure('Position', [figureLocation, figureSize], ...
              'Color',    'white', ...
              'Name',     FILE_FNAME);
hAx  = axes('Units',      'normalized', ...
            'Position',   MAIN_AXE_POSITION);
hold on;

% Plot signal and detected toc starts
plot(tAxis, signal);
plot(tAxis(tocStartIdxArray), signal(tocStartIdxArray), '*r');

% Adapt signal plot
axis tight;
ylim(Y_LIM);

% Axis labels
xlabel('Time [s]');
ylabel('Magnitude [-]');

% Compute zoom axe position
zoomAxeLocation = figureSize .* ZOOM_AXE_RELATIVE_POSITION(1:2);
zoomAxeSize     = figureSize .* ZOOM_AXE_RELATIVE_POSITION(3:4);
zoomAxePosition = [zoomAxeLocation, zoomAxeSize];

% Load data cursor object
dcm_obj = datacursormode(gcf); 

% Start text
fprintf('Start tagging signal ''%s''\n\n', FILE_FNAME);


%%

tagArray = zeros(N_TOC, N_TAG_PER_TOC); % Prealloc
for iToc = START_TOC_ID : N_TOC,
    
    set(gca,'units','pixels');
    pos = get(gca,'position');
    xLim = get(gca,'xlim');
    yLim = get(gca,'ylim');

    
    %% Zoom on selected toc
    
    % Compute toc x position in pixel
    xInAxes   = (tAxis(tocStartIdxArray(iToc)));
    xInPixels = pos(1) + pos(3) * (xInAxes-xLim(1))/(xLim(2)-xLim(1))-1;
    
    % Compute wen width to see all toc impulses
    largPxl   = pos(3) * (TOC_WIDTH-xLim(1))/(xLim(2)-xLim(1));
    
    % Compute wen height to see all toc impulses
    maxi      = max(signal(tocStartIdxArray(iToc)+(0:TOC_WIDTH*fs)));
    maxiPxl   = pos(4) * (maxi-yLim(1)) / (yLim(2)-yLim(1)) + 5; % 5 = offset to see boundaries

    % Build and plot wen and zoom axes
    [h1, h2] = magnify_on_figure_B20(gcf, ...
            'units',                        'pixels', ...
            'initialPositionSecondaryAxes', zoomAxePosition, ...
            'initialPositionMagnifier',     [xInPixels, 0, largPxl, maxiPxl/2], ...
            'mode',                         'manual', ...
            'displayLinkStyle',             'none', ...
            'edgeColor',                    'red', ...
            'secondaryAxesFaceColor',       [0.91, 0.91, 0.91]); % Soft grey 


	%% Detect user tags
    
    if N_TAG_PER_TOC > 0,
        
        nDetectedTag = 0; % init
        while nDetectedTag ~= N_TAG_PER_TOC,

            pause();

            % Extract data cursor position
            info_struct = getCursorInfo(dcm_obj);
            if ~isempty(info_struct),
                tagPosition = [info_struct.Position];
                tagXPosition = tagPosition(end-1:-2:1);

                % If not enough or too much tag are detected, try again
                nDetectedTag = length(tagXPosition);
                if nDetectedTag ~= N_TAG_PER_TOC,
                    tmpString = 'Wrong number of tags (%d detected, should be %d).\n'; 
                    fprintf(tmpString, nDetectedTag, N_TAG_PER_TOC);
                end
            end
        end
    
        % Sort and save detected tags
        tagXPosition = sort(tagXPosition)';
        tagArray(iToc, :) = tagXPosition;
        
    else
        pause();
    end
    
    
    %% Plot detected tags
    
    if N_TAG_PER_TOC > 0,
        fprintf('Toc %d\t', iToc);
        fprintf(['%1.', int2str(N_DIGIT), 'f\t'], tagArray(iToc, :));
        fprintf('\n');
    end

    
   %% Delete zoom and wen
    
    delete(h1);
    delete(h2);
             
end


%% Display tagging results

if N_TAG_PER_TOC > 0,
        
    % Remove time base correction factor from tags
    tagArrayWithoutCorr = tagArray .* TIME_BASE_CORRECTION_FACTOR;

    % Load boolTag
    load('tmp.mat');
    
    % Display results
    fprintf('\nEnd of tagging process for file ''%s''\n', FILE_FNAME);
    fprintf('Tags detected (original time) :\n');
    for iToc2 = 1 : size(tagArrayWithoutCorr, 1),
        fprintf('Toc %d\t', iToc2);
        fprintf(['%1.', int2str(N_DIGIT), 'f\t'], tagArrayWithoutCorr(iToc2, :));
        fprintf('%d\t', moreTag(iToc2, :));
        fprintf('\n');
    end
    fprintf('End of tagging process for file ''%s''\n', FILE_FNAME);

end


%% "Close" script

% Delete moreTag temporary variable
delete('tmp.mat');

% DEV ONLY - Remove local dependencies
if DEV_FLAG, rmpath('..\Dependencies\'); end


% eof
