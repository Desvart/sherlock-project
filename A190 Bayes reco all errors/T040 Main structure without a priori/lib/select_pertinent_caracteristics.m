function carNameCAr = select_pertinent_caracteristics(dataSetRPath, ...
                              eValThresh, plotCarSelBoo, nObsPerFile, fileIdxPerClassCAr)
    % Select only pertinent features (a.k. *** criterion) => statistical analysis Welch + T-test
                                                 

    %% Build caracteristics name cell array
    
    MatFileStruct       = whos('-file', dataSetRPath);
    nCar                = length(MatFileStruct);
    load(dataSetRPath);
    
    carNameCAr = cell(nCar, 1); % Prealloc.
    for iCar = 1 : nCar,
        carNameCAr{iCar} = MatFileStruct(iCar).name;
    end
    
    
    
    %% Store all observations in cell, one cell per class.

    % Prealloc. loop
    nClasses        = length(fileIdxPerClassCAr);
    nFilesPerClassArr   = cellfun(@length, fileIdxPerClassCAr);
    nFiles          = sum(nFilesPerClassArr);
    obsPerClassCAr  = cell(nClasses, 1);
    nObsWNanArr   	= nan(nClasses, nCar);

    % Init. loop
    obs2FileIdxArr    = ( ( 0 : (nFiles-1) )*(nObsPerFile/2) + 1 )' * ones(1, nObsPerFile/2);
    obs2ObsIdxVec     = 0 : ( nObsPerFile/2 - 1 );
    obs2IdxArr        = bsxfun(@plus, obs2FileIdxArr, obs2ObsIdxVec);

    % Start loop
    for iClass = 1 : nClasses,

        
        %%% Load caracteristic variable and store the value corresponding to the actuel class.
        
        % Prealloc. loop
        obsPerClassCAr{iClass}  = nan(nFiles*nObsPerFile, nCar);

        % Init. loop
        obsIdx2                 = obs2IdxArr(fileIdxPerClassCAr{iClass}, :)';
        obsIdx2                 = obsIdx2(:);
        nObs                    = length(obsIdx2) * 2;
        
        % Start loop
        for iCar = 1 : nCar,
            
            % Eval string of the caracteristic variable
            carValArr                            = eval(carNameCAr{iCar});
            % Extract the caracteristics belonging to the actual class
            carValForThisClassArr                = carValArr(obsIdx2, :)';
            % Store those value in column vector in the correct cell
            obsPerClassCAr{iClass}(1:nObs, iCar) = carValForThisClassArr(:);
            
        end

        
        %%% Compute the number of caracteristics discarding NaN values.
        
        nObsWNanArr(iClass, :) = size(obsPerClassCAr{iClass}, 1) - sum(isnan(obsPerClassCAr{iClass}));

    end % for iClass = 1 : nClasses,
    
    
    
    %% Compute Baysian statistics for each class and caracteristics

    muObsArr                = cell2mat(cellfun(@nanmean, obsPerClassCAr, 'UniformOutput', false));
    sigmaObsArr             = cell2mat(cellfun(@nanstd,  obsPerClassCAr, 'UniformOutput', false));

    
    
    %% Determine statistical significance of each caracteristics 
    
    
    %%% Compute welch test
    
    welchNumerator          = abs( muObsArr(1, :) - muObsArr(2, :) );
    welchS1                 = ( sigmaObsArr(1, :).^2 ) ./ nObsWNanArr(1, :);
    welchS2                 = ( sigmaObsArr(2, :).^2 ) ./ nObsWNanArr(2, :);
    welchTest               = welchNumerator ./ sqrt( welchS1 + welchS2 );

    
    %%% Compute welch degree of freedom
    
    welchDofNumerator       = (welchS1 + welchS2).^2;
    welchDofDenominator1    = (welchS1.^2) ./ (nObsWNanArr(1, :) - 1);
    welchDofDenominator2    = (welchS2.^2) ./ (nObsWNanArr(2, :) - 1);
    welchDof                = welchDofNumerator ./ ( welchDofDenominator1 + welchDofDenominator2 );

    
    %%% Compute p-value and e-value
    
    pVal                    = 1 - tcdf(welchTest, welchDof-1);
    bonferroniFact          = max(nObsWNanArr);
    eVal                    = bonferroniFact .* pVal;

    
    %%% Threshold e-value for ** and *** criteria
    
    eValStarredIdx3         = find(eVal < eValThresh);
    eValStarred3            = eVal(eValStarredIdx3);
    eValStarredIdx2         = find(eVal < eValThresh*10);
    eValStarred2            = eVal(eValStarredIdx2);
    
    [f11, idx1] = sort(pVal);
    i21 = find(f11 > (1/1000 ./ (length(f11):-1:1)), 1, 'first');
    
    eVal1 = pVal(idx1(1:i21-1));
    
    
    %% Compute test fisher
    
    F = sigmaObsArr(1, :).^2 ./ sigmaObsArr(2, :).^2;
    
    for i = 1 : length(F),
    
        if F(i) < 1,
            
            F(i) = 1/F(i);
        
            nC1 = nObsWNanArr(2)-1;
            nC2 = nObsWNanArr(1)-1;
        else
            nC1 = nObsWNanArr(1)-1;
            nC2 = nObsWNanArr(2)-1;
        end
        
        fPVal(i) = 1 - fcdf(F(i), nC1, nC2);
        
    end
    
%     fEVal = bonferroniFact .* fPVal;
    
    [f1, idx] = sort(fPVal);
    i2 = find(f1 > (5/1000 ./ (length(f1):-1:1)), 1, 'first');
    
    fEVal = fPVal(idx(1:i2-1));

    

    %% Plot e-values of each caracteristics

    if plotCarSelBoo == true,
        
        
        %%% Create figure
        
        screenSize          = get(0, 'ScreenSize');
        plotPosition        = [screenSize(3), 1, screenSize(3:4)];

        figure('Color',         'white', ...
               'OuterPosition', plotPosition);
        hold on;

        
        %%% Plot e-values
        
        plot(eValStarredIdx2, eValStarred2*100, '*g'); 
        plot(eValStarredIdx3, eValStarred3*100, '*r'); 
        plot(idx((1:i2-1)), fEVal*100, 'ok');
        plot(idx1((1:i21-1)), eVal1*100, 'oc');

        
        %%% Plot 1/1000 and 1/100 threshold lines
        
        xLim = [1, nCar];
        line(xLim, eValThresh*100*ones(1,2), 'Color', 'red');
        line(xLim, eValThresh*100*10*ones(1,2), 'Color', 'green');
        ylim([0, 1]);

        
        %%% Change x-ticks to display caracteristic names and caracteristic index
        
        tickNamesCAr = carNameCAr;
        for iCar = eValStarredIdx2,
            if any(iCar == eValStarredIdx3),
                tickNamesCAr{iCar} = ['\color{red}', carNameCAr{iCar}];
            else
                tickNamesCAr{iCar} = ['\color{green}', carNameCAr{iCar}];
            end
        end

        xTickIdx = 1:nCar;
        set(gca,'XTick', xTickIdx, 'XLim', xLim);
        t = text(xTickIdx, -0.015*ones(1, length(xTickIdx)), tickNamesCAr);
        set(t,  'HorizontalAlignment',  'right',    ...
                'VerticalAlignment',    'top',      ...
                'Rotation',             45);

            
        %%% Display x and y labels
        
        ylabel('E-value [%]');

        % X label (the complex way due to sub-tick label adjunction).
        ext = nan(length(t), 4); % Prealloc.
        for i = 1 : length(t),
            ext(i, :) = get(t(i), 'Extent');
        end
        lowYPoint = min(ext(:,2));
        xMidPoint = xLim(1) + abs(diff(xLim)) / 2;
        tl = text(xMidPoint, lowYPoint/1.5, 'Caracteristics', ...
                    'VerticalAlignment',    'top', ...
                    'HorizontalAlignment',  'center');
                
    end

   
    
    %% Define features to keep
    % Use statistical pertinent analysis to determine the better alone features and plot histogram of 
    % each of those features. Then choose the ones which have a "gaussian" like shape.

    nCarToKeep = length(eValStarredIdx2);

    obsPerClassCAr = cell(2, 1); % Prealloc.
    for iClass = 1 : nClasses,

        % Prealloc. & init. loop
        obsPerClassCAr{iClass}  = nan(nFilesPerClassArr(1), nCarToKeep);
        obsIdx2                 = obs2IdxArr(fileIdxPerClassCAr{iClass}, :)';
        obsIdx2                 = obsIdx2(:);
        nObs                    = length(obsIdx2) * 2;

        % Start loop
        for iCarSubset = 1 : nCarToKeep,
            carName         	  = carNameCAr{eValStarredIdx2(iCarSubset)};
            carValArr             = eval(carName);
            carValForThisClassArr = carValArr(obsIdx2, :)';
            obsPerClassCAr{iClass}(1:nObs, iCarSubset) = carValForThisClassArr(:);
        end

    end

    
    
    %% Plot histogram of the 15th most significant caracteristics
    
    if plotCarSelBoo == true,

        figure('Color',         'white', ...
               'OuterPosition', plotPosition);

        nHistBin = 25;
        for iCarSubset = 1 : nCarToKeep,

            subplot(3, 5, iCarSubset);
            hold on;

            [a, b] = hist(obsPerClassCAr{1}(:, iCarSubset), nHistBin);
            [c, d] = hist(obsPerClassCAr{2}(:, iCarSubset), nHistBin);

            bar(b, a, 'r', 'EdgeColor', 'none', 'BarWidth', 0.8);
            bar(d, c, 'b', 'EdgeColor', 'none', 'BarWidth', 0.4);

            carIdx      = eValStarredIdx2(iCarSubset);
            titleStr    = sprintf('%s (#%d)', carNameCAr{carIdx}, carIdx);
            title(titleStr);

%         end
    
    end

    
    
    %%

%     featureNameArray = carNameCAr(caracteristicsToKeepIdx);                                                         
                                              
                                              
end

% eof
