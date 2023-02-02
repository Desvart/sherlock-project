function SHH_ESPS()
% # Stocker les données dans des fichiers mat-file :
%   - 1 fichier par mouvement : 
%       + ML156-01c_R00_B0x, 
%       + ML156-02c_R00_B0x, 
%       + ML156-03c_R00_B0x;
%   - structure du fichier :
%       + 1 variable par niveau de barillet :
%           . ML156-0xc_R00_B01
%           . ML156-0xc_R00_B02
%           . ML156-0xc_R00_B03
%           . ML156-0xc_R00_B04
%           . ML156-0xc_R00_B05
%           . ML156-0xc_R00_B06
%       + structure de la variable :
%           . 1 ligne par toc
%           . 1 colonne par tag/flag selon la structure suivante:
%               - tocId	
%               - degS	
%               - degB	
%               - pChuteS	
%               - impS	
%               - ufoS	
%               - chuteS	
%               - chuteB1	
%               - chuteB2	
%               - isCam	
%               - isDegB	
%               - isUfo
%
% DONE # Ajouter qui est tic et qui est tac 
%
% DONE # Extraire les maxima relatifs des signaux et les insérer dans les données:
%   - degRM, 
%   - degBRM, 
%   - impRM, 
%   - ufoRM,
%   - chuteRM
%
% DONE # Extraire les maxima absolus (idem que relatifs) des signaux originaux et les insérer dans les 
%   données.
%
% DONE # Estimer la fin de chaque toc et entrer cette valeur dans les données.
%
% # Extraire les distances d'intérêt de signaux et les stocker dans le fichier de données :
%   - degS-degB, 
%   - degS-pChuteS,  
%   - degS-chuteS,  
%   - degS-chuteEnd,  
%   - pChuteS-impS,  
%   - chuteS-chuteB2,  
%   - degS-ufoS
%
% # Estimer les énergies d'intérêt et les stocker dans le fichier de données :
%   - degE, 
%   - degBE,  
%   - pChuteE,  
%   - impE,  
%   - ufoE,  
%   - chuteE,  
%   - chuteB2E
%
% # Estimer la puissance liée aux énergies calculées
%
% # Calculer spectre 1D pour estimer la position et la puissance des harmoniques des blocs
%   suivants :
%   - degS-degB, 
%   - degB-pChuteS,  
%   - pChuteS-impS,  
%   - impS-ufoS,  
%   - ufoS-chuteS,  
%   - chuteS-chuteB1,  
%   - chuteB1-chuteB2,  
%   - chuteB2-chuteEnd


    %% SVN
    
%     dbStack = dbstack();
%     fileFullPathWithoutExtension = mfilename('fullpath');
%     fileExtension = dbStack.file(length(dbStack.name)+1:end);
%     fileFPath = [fileFullPathWithoutExtension, fileExtension];
%     dateStr = datestr(now, 'yyyy.mm.dd - HH:MM:SS.FFF');
%     svnRequest = ['!TortoiseProc.exe /command:commit ', ...
%                   '/path:"', fileFPath, '" ', ...
%                   '/logmsg:"Compilation : ', dateStr, '" ', ...
%                   '/closeonend:0'];
%     eval(svnRequest);


    %% Init script
    
    %%%
    clear all;
    close all;
    clc;
    
    %%% Add lib path
    addpath('./lib/');

    %%% Script variables
    FILE_NAME_TO_LOAD = 'visoBarilletDatasetModif.mat'; % Contains "datasetSignal" and "datasetToc"
    VERBOSE = true;
    DEBUG = true;
    N_STEPS = 4;
   
    %%% Init
    % Command window script chronology informations
    clockStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF');
    dispv('%s - Script takes control (T = 00:00:00.000).\n\n', clockStr, VERBOSE); 
    mainTic = tic();
    % Init script values
    datasetToc = 0;
    datasetSignal = 0;
    iStep = 1;
    % Load original datasets
    load(FILE_NAME_TO_LOAD);


    %% Convert existing time in samples
    
    dispString = 'Conversion of time tags to sample tags.';
    stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, VERBOSE);
    
    fs = 200e3; % S/s
    datasetToc2 = datasetToc;
    datasetToc(:, 4:11) = mat2dataset(round(double(datasetToc(:, 4:11)).*fs));
    
    iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, VERBOSE);


    %% 'isTic' - Determine if a toc is a "tic" or a "tac" and store this information in the dataset
    % N.B.: "Tic" and "tac" describe series of shocks that occurs in a watch escapement during one
    % alternation of the balance. "Tic" is used when the main shock, namely "drop", is done on the
    % entry pallet-stone (in other words, it means that the unlocking is done on the entry horn of
    % the fork). "Tac" is used complementarily when the main shock is done on the exit pallet-stone.
    % "Toc" is a generic term to talk indiscriminately about a "tic" or a "tac", usualy we use
    % the term "toc" because we don't know if we are talking about a "tic" or a "tac".
    
    dispString = 'Determine who is tic or tac.';
    stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, VERBOSE);
      
    datasetToc = ESPS_determine_isTic(datasetToc);
    
    iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, VERBOSE);

    
    %% Maximum values - Extract maximum values of each meaningful energy paquet.
    % 

    dispString = 'Extract maxima of each energy block.';
    stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, VERBOSE);
      
    datasetToc = ESPS_extract_all_max(datasetSignal, datasetToc);
    
    iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, VERBOSE);
    
    
    %% End of toc - Estimate the end of each tocs.
    %
    
    dispString = 'Estimate toc end.';
    stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, VERBOSE);
      
%     datasetToc = ESPS_estimate_toc_end(datasetSignal, datasetToc, VERBOSE, DEBUG,datasetToc2);
    
    iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, VERBOSE);
    
    
    %% Distances - Estimante distances between various tag
    %
    
    dispString = 'Compute tag distance.';
    stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, VERBOSE);
      
    datasetToc = ESPS_compute_tag_distance(datasetToc, VERBOSE, DEBUG);
    
    iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, VERBOSE);
    
    
    %% Save extracted data
    %
        
    dispString = 'Save gathered data.';
    stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, VERBOSE);
    
    save('visoBarilletDataset3.mat', 'datasetSignal', 'datasetToc');
    
    iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, VERBOSE);
      
    nowStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF'); 
    dispv('\n%s - Script releases control (%s).\n', nowStr, s2hms(toc(mainTic)), VERBOSE);
    
    
    %% Remove lib path
    rmpath('./lib/');

end



function datasetToc = ESPS_determine_isTic(datasetToc, nMvts, nBarilletLevels, nTocs)
%
%
%


    %% Init.
    [nMvts, nBarilletLevels, nTocs, nObservations] = ESPS_init_subfunctions(datasetToc);


    %%% Determine 'isTic' variable
    isTicArray = cell(nObservations, 1); % Prealloc.
    stopObsId   = 0;                     % Init.
    for iMvt = 1 : nMvts,
        mvtId = ['ML156-0', int2str(iMvt), 'c'];

        for iBalancierLevel = 1 : nBarilletLevels,

            dsRequest    = strcmp(datasetToc.mvtId, mvtId) & datasetToc.barilletLevel == iBalancierLevel;
            dsAnswer     = datasetToc(dsRequest, {'isCam'});
            isCam        = double(dsAnswer);

            ticDetectPos = find(isCam, 1, 'first');

            startObsId = stopObsId + 1;
            stopObsId  = startObsId + nTocs - 1;
            if mod(ticDetectPos, 2) == 1, % is odd
                isTicArray(startObsId:stopObsId) = {'Tic'; 'Tac'; 'Tic'; 'Tac'; 'Tic'; 'Tac'; ...
                                                    'Tic'; 'Tac'; 'Tic'; 'Tac'; 'Tic'; 'Tac'};
            else %is even
                isTicArray(startObsId:stopObsId) = {'Tac'; 'Tic'; 'Tac'; 'Tic'; 'Tac'; 'Tic'; ...
                                                    'Tac'; 'Tic'; 'Tac'; 'Tic'; 'Tac'; 'Tic'};
            end
        end
    end

    %%% Store determined 'isTic' variable in dataset 'datasetToc'
    varName = 'isTic';
    if any(strcmp(varName, datasetToc.Properties.VarNames)) == false, % if 'isTic' variable doesn't exist
        datasetToc = horzcat(datasetToc, dataset(isTicArray, 'VarNames', varName));
    else % if 'isTic' variable already exists
        datasetToc.isTic = isTicArray;
    end

end



function datasetToc = ESPS_extract_all_max(datasetSignal, datasetToc)
% Create all max variables
%
%
    
    %% Init.
    
    [nMvts, nBarilletLevels, nTocs, nObservations, nVars] = ESPS_init_subfunctions(datasetToc);
    
    
    %% Fill all max variables

    intervalRef   = [1:2,4:6];
    nInterval = length(intervalRef);

    maxMArray = zeros(nObservations, nInterval*2); % Prealloc.
    obsId = 0;
    for iMvt = 1 : nMvts,
        mvtId = ['ML156-0', int2str(iMvt), 'c'];

        for iBarilletLevel = 1 : nBarilletLevels,
            %% Load signal
            dsRequest    = strcmp(datasetSignal.mvtId, mvtId) & datasetSignal.barilletLevel == iBarilletLevel;
            dsAnswer     = datasetSignal(dsRequest, {'signal', 'normFactor'});
            signal       = dsAnswer.signal;
            normFactor   = dsAnswer.normFactor;

            for iToc = 1 : nTocs,
                %% Load toc positions
                dsRequest     = strcmp(datasetToc.mvtId, mvtId) & datasetToc.barilletLevel == iBarilletLevel & datasetToc.tocId == iToc;
                tocTagTIdx    = double(datasetToc(dsRequest, 4:10));

                intervalArray = [tocTagTIdx(intervalRef)', tocTagTIdx(intervalRef+1)'];

                obsId         = obsId + 1;

                for iInterval = 1 : nInterval,
                    %%
                    startMaxId = (iInterval-1)*2 + 1;
                    maxM = max(signal(intervalArray(iInterval, 1) : intervalArray(iInterval, 2)));

                    maxMArray(obsId, startMaxId:startMaxId+1) = [maxM, maxM*normFactor];

                end
            end        
        end
    end

    %% Store determined 'isTic' variable in dataset 'datasetToc'

	newVarNamesArray = {'degRM', 'degAM', 'degBRM', 'degBAM', 'impRM', 'impAM', ...
                        'ufoRM', 'ufoAM', 'chuteRM', 'chuteAM'};
	nNewVars = length(newVarNamesArray);
    
    if any(strcmp('degRM', datasetToc.Properties.VarNames)) == false, % if 'degRM' variable doesn't exist
        datasetToc = horzcat(datasetToc, mat2dataset(maxMArray, 'VarNames', newVarNamesArray));
    else % if 'degRM' variable already exists
        datasetToc(:, nVars:nVars+nNewVars-1) = mat2dataset(maxMArray);
    end

end


function datasetToc = ESPS_estimate_toc_end(datasetSignal, datasetToc, verbose, debug, datasetToc2)
% Estimate end of toc
%
%

    %%
    [nMvts, nBarilletLevels, nTocs, nObservations, nVars] = ESPS_init_subfunctions(datasetToc);
    
    nTocsTot = nTocs*nBarilletLevels*nMvts;
    waitbarStr = 'Please wait. Processing toc %d/%d...';
    waitbarH   = waitbarv(waitbarStr, nTocsTot, verbose);
    
    relId = absId_2_relId([nMvts, nBarilletLevels, nTocs], 1);
%     relId = absId_2_relId([nMvts, nBarilletLevels, nTocs], 216-11);
    
    %% Fill tocEnd variables
    figure('color', 'white');
    tocEndArray = zeros(nObservations, 1); % Init.
    for iMvt = relId(1) : nMvts,
        mvtId = ['ML156-0', int2str(iMvt), 'c'];

        for iBarilletLevel = relId(2) : nBarilletLevels,

            %% Load signal
            mvtRequest           = strcmp(datasetSignal.mvtId, mvtId);
            barilletLevelRequest = datasetSignal.barilletLevel == iBarilletLevel;
            datasetRequest       = mvtRequest & barilletLevelRequest;
            datasetAnswer        = datasetSignal(datasetRequest, {'signal'});
            signal               = double(datasetAnswer.signal);
            nSignals             = length(signal);
            
            if debug == true,
                clf; hold on;
                plot(db(signal));
            end
            
            previousNoiseLevelDb = 0;
            for iToc = relId(3) : nTocs,

                windowLength = 500;

                %% Load tags
                
                %%% Extract Chute start tag 
                % Build dataset request
                mvtRequest           = strcmp(datasetToc.mvtId, mvtId);
                barilletLevelRequest = datasetToc.barilletLevel == iBarilletLevel;
                tocRequest           = datasetToc.tocId == iToc;
                datasetRequest       = mvtRequest & barilletLevelRequest & tocRequest;
                % Send request and convert values into double
                datasetAnswer        = datasetToc(datasetRequest, {'chuteS'});
                chuteS               = double(datasetAnswer.chuteS);

                if iToc < nTocs, 
                    %%% Extract Degagement start tag for next toc.
                    % Build dataset request
                    tocRequest           = datasetToc.tocId == iToc+1;
                    datasetRequest       = mvtRequest & barilletLevelRequest & tocRequest;
                    % Send request and convert values into double
                    datasetAnswer        = datasetToc(datasetRequest, {'degS'});
                    degS                 = double(datasetAnswer.degS);
                else
                    degS                 = nSignals;
                end

                
                %% Preprocess signal to usefull form
                
                %%% Load RoI signal
                roiSignal   = signal(chuteS:degS);
                nRoiSamples = length(roiSignal);
                
                %%% Perform simple moving standard deviation (SMSTD) (backward version)
                smStd = zeros(1, nRoiSamples); % Init. loop
                for iSample = windowLength : nRoiSamples,
                    smStd(iSample) = std(roiSignal(iSample-windowLength+1 : iSample));
                end

                
                %% Estimate noise level
                % This noise is estimate on a signal sample locate before a new toc. This sample of
                % signal is estimate to be representative of the noise. The length of this sample is
                % 1/3 of the distance between current 'chute' tag and next 'degagement' tag. The
                % noise level is estimate to be the mean level of this sample signal in decibel plus
                % 6 times the standard deviation of this sample signal in decibel.
                
                %%% Extract and transform signal sample used to estimate noise level.
                nSamplesToEstimateNoiseLevel      = round((degS - chuteS) / 3);
                signaleUsedToEstimateNoiseLevel   = smStd(end-nSamplesToEstimateNoiseLevel:end);
                signaleUsedToEstimateNoiseLevelDb = db(signaleUsedToEstimateNoiseLevel);
                
                %%% Compute noise level.
                smstdMeanDb                       = mean(signaleUsedToEstimateNoiseLevelDb);
                smstdStdDb                        = std(signaleUsedToEstimateNoiseLevelDb);
                if iToc < nTocs,
                    noiseLevelDb                  = smstdMeanDb + 3*smstdStdDb;
                    previousNoiseLevelDb          = noiseLevelDb;
                else
                    noiseLevelDb = previousNoiseLevelDb; % Keep previously computed noise level.
                end

                
                %% Detect toc end

                isNoise          = db(smStd(windowLength:end)) < noiseLevelDb;
                tocEndRIdx       = find(isNoise, 1, 'first');
                tocEndIdx        = chuteS + tocEndRIdx;
                
                if debug == true,
                    plot(chuteS:degS, db(smStd), 'r');
                    plot(chuteS + find(isNoise), db(smStd(find(isNoise))), 'g');
                    plot(tocEndIdx, db(signal(tocEndIdx)), '*r');
                end
                
                
                %% Store toc end in an array.
                
                tocAIdx = (iMvt-1)*nBarilletLevels*nTocs + (iBarilletLevel-1)*nTocs + iToc;
                tocEndArray(tocAIdx) = tocEndIdx;
                
                
                %% Store detected value in dataset
                
                waitbarv(waitbarH, waitbarStr, tocAIdx, nTocsTot, verbose);

            end            
        end
    end
    
    
    %% Store determined 'tocEnd' variable in dataset 'datasetToc'
    
    varName = 'tocEnd';
    if any(strcmp(varName, datasetToc.Properties.VarNames)) == false, % if 'tocEnd' variable doesn't exist
        datasetToc = horzcat(datasetToc, dataset(tocEndArray, 'VarNames', varName));
    else % if 'tocEnd' variable already exists
        datasetToc.tocEnd = tocEndArray;
    end
    
    close(waitbarH);
    
end


function datasetToc = ESPS_compute_tag_distance(datasetToc, verbose, debug)
%
%

	%%
    
    [nMvts, nBarilletLevels, nTocs, nObservations, nVars] = ESPS_init_subfunctions(datasetToc);
    
    nTocsTot = nTocs * nBarilletLevels * nMvts;

    relId = absId_2_relId([nMvts, nBarilletLevels, nTocs], 1);
%     relId = absId_2_relId([nMvts, nBarilletLevels, nTocs], 216-11);
    

    %% 
    
    tocEndArray = zeros(nObservations, 1); % Init.
    for iMvt = relId(1) : nMvts,
        mvtId = ['ML156-0', int2str(iMvt), 'c'];

        for iBarilletLevel = relId(2) : nBarilletLevels,
            
            for iToc = relId(3) : nTocs,
                
                %%% Compute distDegSDegB
                
                %%% Compute distDegSPChuteS
                
                %%% Compute distDegSChuteS
                
                %%% Compute distDegSB
                
                
                %   - degS-degB, 
%   - degS-pChuteS,  
%   - degS-chuteS,  
%   - degS-chuteEnd,  
%   - pChuteS-impS,  
%   - chuteS-chuteB2,  
%   - degS-ufoS
                
            end
        end
    end
    
    
    %% Store computed values in dataset 'datasetToc'
    
    varName = 'distDegSB';
    if any(strcmp(varName, datasetToc.Properties.VarNames)) == false, % if variable doesn't exist
        datasetToc = horzcat(datasetToc, dataset(tocEndArray, 'VarNames', varName));
    else % if variable already exists
        datasetToc.tocEnd = tocEndArray;
    end

end


function [nMvts, nBarilletLevels, nTocs, nObservations, nVars] = ESPS_init_subfunctions(datasetToc)
%
%
%


    [nObservations, nVars] = size(datasetToc);
    datasetAnswer = datasetToc(nObservations, {'mvtId', 'barilletLevel', 'tocId'});
    
    mvtIdStr = datasetAnswer.mvtId;
    nMvts = str2double(mvtIdStr{1}(end-1));
    
    nBarilletLevels = datasetAnswer.barilletLevel;
    
    nTocs = datasetAnswer.tocId;
    
end


function stepTic = ESPS_disp_start_step(dispString, iStep, N_STEPS, mainTic, verbose)

    stepTic = tic();
    dispv(['Step %d/%d : ', dispString, ' \n', ...
           'Start step : %s.\n'], ...
           iStep, N_STEPS, s2hms(toc(mainTic)), verbose);
       
end


function iStep = ESPS_disp_finish_step(mainTic, stepTic, iStep, verbose)

    dispv('Finish step : %s (Step duration : %s).\n', ...
          s2hms(toc(mainTic)), s2hms(toc(stepTic)), verbose);
    iStep = iStep + 1;
    
end

% eof
