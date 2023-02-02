function thirdPulseIdx = third_pulse_localization(signal, fs)
% THIRD_PULSE_LOCALIZATION looks for locations of maximum energy in each tocs. On most classical
%       cases the maximum energy pulse correspond to the third pulse.
%   
% Notes : this algorithm processes signal only in time-domain and without any delay.
%
% Inputs
%   - signal    raw tic-tac signal to analyse
%   - fs        sampling frequency of signal
%
% Outputs
%   - thirdPulseIdx     Indexes of maximum energy detected for each tocs.



%%% D�tection grossi�re de la 3�me impulsion (M�thode 20120126-01)
%%% Id�e de base: 
%       1. Seuil simple � -20 dB sur la puissance en db et normalis�e � max = 0 dB 
%       2. D�tection des max dans les zones o� il y a un signal
%       3. Elimination des doubles pics proches avec une fen�tre d'analyse de 40 ms (largeur 
%          temporelle double de celle statistique d'un toc "normal")
%
%%% Impl�mentation: 
%       1. Calcul de l'�nergie (signal.^2) normalis�e (max = 1) du signal.
%       2. Seuil simple > 0.05 (~ -26 dB) sur l'�nergie (1.)
%       3. Localisation des blocs de donn�es au-del� du seuil (2.)
%           3.1 Gradiant du signal seuill�
%           3.2 Seuil du gradiant (3.1) > 1
%       4. Suppression des blocs trop proches des bords (les 40 premi�res et derni�res 
%          millisecondes) du signal et qui pourraient �tre potentiellement tronqu�s.
%       5. Boucle sur chaque �l�ments des blocs
%           5.1 On calcule la distance entre l'�l�ment courant et l'�l�ment d'avant.
%           5.2 Si la distance est s�p�rieur � 40 ms on en d�duit qu'on a fini de d�limiter le bloc
%           pr�c�dent.
%           5.3 On localise le maximum d'�nergie du signal dans une fen�tre qui commence au premier
%           �l�ment du bloc pr�c�dent (5.2) et qui se termine 40 ms plus tard.
%           5.4 On recommence la boucle jusqu'� faire tous les blocs.



%%% D�tection grossi�re de la 3�me impulsion (M�thode 20120126-02)
% Id�e de base: 
%       1. Mesure du niveau de bruit du signal (en dB) normalis� � maxSignal = 0 dB
%           1.1 Construction d'une enveloppe sup�rieure grossi�re du signal
%           1.2 Calcul de la moyenne (m�diane?) de l'enveloppe 1.1 = niveau de bruit
%           1.3 Calcul de la dynamique du signal (max - niveau de bruit)
%       1. Seuil simple � x% de la dynamique sur l'�nergie en db et normalis�e � max = 0 dB 
%       2. �limination des doubles pics proches avec une fen�tre d'analyse de 40 m (largeur 
%          temporelle double de celle statistique d'un toc "normal")



% Project Sherlock Holmes
% Author: Pitch Corp.  -  2012.01.26
% ------------------------------------------------------------------------------------------------ %
    
    %%% Internal param
    energyThreshold = 0.05;
    sWindow = fs*40e-3;
    
    
    energy = signal.^2;
    maxEnergy = max(energy);
    energyNorm = energy ./ maxEnergy;
    
    energyThresholded = sparse(energyNorm >= energyThreshold);
    rawLocalisation = find(energyThresholded);
    findBloc = rawLocalisation(2:end) - rawLocalisation(1:end-1);
    blocSparseIdx = [1, find(findBloc > 1)+1];
    blocIdx = rawLocalisation(blocSparseIdx);
    
    % S�curit� pour �viter de prendre des �v�nements qui sont trop proches des bords du signal et
    % qui risquent d'�tre tronqu�s.
    blocIdx = blocIdx(blocIdx > sWindow  &  blocIdx < length(signal)-sWindow);
    
    
    thirdPulseIdx       = 0;
    actualBlocFirstIdx  = blocIdx(1);
    nThirdPulse         = 1;
    nBloc               = length(blocIdx);
    for iBloc = 2 : nBloc,
        
        if blocIdx(iBloc) - blocIdx(iBloc-1) > sWindow || iBloc == nBloc,
            actualBlocIdx = actualBlocFirstIdx:actualBlocFirstIdx+sWindow;
            [~, locationMaxEnergy] = max(energyNorm(actualBlocIdx)); 
            thirdPulseIdx(nThirdPulse) = actualBlocIdx(locationMaxEnergy);%#ok<AGROW>
            nThirdPulse = nThirdPulse + 1;
            actualBlocFirstIdx = blocIdx(iBloc);
        end
        
    end
    
end
