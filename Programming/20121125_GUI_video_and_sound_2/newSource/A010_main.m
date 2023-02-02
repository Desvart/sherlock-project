% GUI ViSo 2.0
%

% Project   : Sherlock Holmes - ViSo
% File vers.: Alpha 1 (2012.12.11)
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Note : 
% - 

% Todo : 
% 1.  Cr�er la GUI
% 2.  Initialiser la GUI
% 3.  Impl�menter le module de chargement d'une acquisition ViSo
% 4.  Impl�menter le module d'affichage vid�o
% 5.  Impl�menter le module d'affichage de l'information
% 6.  Impl�menter le module d'affichage temporel global
% 7.  Impl�menter le module d'affichage temporel par toc
% 8.  Impl�menter le module de gestion des boutons �nergie et �galisation
% 9.  Impl�menter le module de gestion des boutons Toc suivant et Toc pr�c�dent
% 10. Impl�menter le module de gestion des boutons Frame suivante et Frame pr�c�dente
% 11. Impl�menter le module de gestion des boutons au clavier
% 12. Impl�menter le module d'affichage de la STDFT 

% Log :
% A1 2012.12.11 - 2012.09.??
%   - Create function



%% Declare script parameters

close all;
clear all;
clc;

PROJECT_ROOT_FULLPATH        = '.\\Ongoing\ABP011_Sherlock_Holmes\';
DATABASE_ROOT_FULLPATH       = [PROJECT_ROOT_FULLPATH, 'Data\Videos\ViSo\'];
DATABASE_DEFAULT_FULLPATH    = [DATABASE_ROOT_FULLPATH, 'ViSo_2_0\ML_Influence_du_barillet\'];
NAME_OF_SELECTED_ACQUISITION = 'ML01_R00_B01_N01';

% Position corrections to correctly display figure borders on selected monitor
    % With menu bar and toolbar
% MONITOR_POSITION_CORRECTION(1, :) = [-72, -8, 79, 91]; % Primary monitor: Windows bar is displayed on left side of the screen
% MONITOR_POSITION_CORRECTION(2, :) = [ -8, -8, 16, 91]; % Secondary monitor: No windows bar is displayed on this screen
    % Without menu bar and toolbar
MONITOR_POSITION_CORRECTION(1, :) = [-72, -8, 79, 37]; % Primary monitor:Windows bar is displayed on left side of the screen
MONITOR_POSITION_CORRECTION(2, :) = [ -8, -8, 16, 37]; % Secondary monitor: No windows bar is displayed on this screen



%% Initialize script

[mainFigurePosition, isMonoMonitor] = shh_initialize_viso_gui(MONITOR_POSITION_CORRECTION, ...
                                                              DATABASE_DEFAULT_FULLPATH, ...
                                                              NAME_OF_SELECTED_ACQUISITION);



%% Build GUI

hMainFig = shh_create_viso_gui(mainFigurePosition);



%% Init GUI

set(hMainFig, 'Visible', 'on');


% eof
