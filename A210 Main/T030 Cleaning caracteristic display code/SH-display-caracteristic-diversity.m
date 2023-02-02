% Project : Sherlock Holmes
%
% © 2012-2015
%   Build   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64
%             Matlab R2013a (8.1.0.604) x64 - Windows 7 x64

% History
% 1.0.b0.0???	First functionnal version
% 0.1.a0.0015	Change script output
%       New output is the confusion matrix, a table contaning various accuracy indicators and the 
%       chance level of the classificator.
% 0.0.a0.0000	File creation (2013.07.10)

% Notes
% COV matlab function has been checked. All green.
% PCA matlab function has been checked. All green.

% Lexicon
% feat              feature
% car               caracteristic
% obs               observation
% L{File; Obs}      Learning file (a.k. training file) or observation
% T{File; Obs}      Testing file or observation
% n{Feat; Obs}      number of features or observations
% ELabel            estimate label
% Arr               Array
% Vec               Vector
% CAr               Cell array
% Boo               Boolean
% thresh            Threshold
% val               Value
% sel               Selection



%% Init. environment


%%% Clean workspace

close all;
clear all;
clc;



%% Define script variables

%%% Files and observations useful values

nObsPerFile     = 10;


%%% Index of files belonging to class 'x'

classE00        = [1,2, 9,10, 17,18, 25:30];
classE01        = [3:4, 11:12, 19:20];
classE02        = [5:6, 13:14, 21:22];
classE03        = [7:8, 15:16, 23:24];
classE0x        = sort([classE01, classE02, classE03]);


%%% "Fake" data
muFakeArr       = [1, 2;...
                   6, 4];
sigmaFakeCAr    = {[1.0, 0.5;  ...
                    0.5, 2.0], ...
                   [3.0, 0.5;  ...
                    0.5, 1.0]}; 


                
%% Extract global informations


%%% Various number of elements

fileIdxPerClassCAr  = {classE00; classE0x};
nClasses            = length(fileIdxPerClassCAr);

nFilesPerClassArr   = cellfun('length', fileIdxPerClassCAr);
nFiles              = sum(nFilesPerClassArr);

nObsPerClassArr     = nFilesPerClassArr * nObsPerFile;
nObs                = sum(nObsPerClassArr);



%% Load data and build dataset


nObsPerFile     = 10;
nFeats          = 2;
nObsPerClassArr = [120, 180];

g{1} = repmat(muFakeArr(1, :), [nObsPerClassArr(1), 1]) + randn(nObsPerClassArr(1), 2)*chol(sigmaFakeCAr{1});
g{2} = repmat(muFakeArr(2, :), [nObsPerClassArr(2), 1]) + randn(nObsPerClassArr(2), 2)*chol(sigmaFakeCAr{2});

allObsArr = rand(nFiles, nObsPerFile, nFeats); % Prealloc.
for iClass = 1 : nClasses,
    
    i  = 0; % Init.
    for iFile = fileIdxPerClassCAr{iClass},
        
        i                       = i + 1;
        allObsArr(iFile, :, :)  = g{iClass}( (i-1)*nObsPerFile + (1 : nObsPerFile), :);
        
    end
    
end

nCarKept        = 2;
carKeptNameCAr  = {'fakeCar1', 'fakeCar2'};

















%% Plot feature space
%   allObsArr           [nFiles x nTocs x nCar]
%   fileIdxPerClassCAr  {[1 x nFilesPerClass1], ... [1 x nFilesPerClassN]}
%   nClasses
%   nFiles
%   nObsPerFile
%   nCarKept
%   carKeptNameCAr


screenSize   = get(0, 'ScreenSize');
plotPosition = [screenSize(3), 1, screenSize(3:4)];

figure('Color',         'white', ...
       'OuterPosition', plotPosition);

classTagStr     = 'xx';
colArr          = 'rb';
histMarkerStr   = 'os';


%%% Plot all caracteristics so one can compare the diversity of each file.

for iCar = 1 : nCarKept,     
    
    
    %%% Build axe
    
    axesXPos = ((iCar-1)*(100/nCarKept) + 1.5 ) / 100;
    axesYPos = (40-1.5) / 100;
    axesW    = (100/nCarKept - 1.5) / 100; 
    axesH    = 60 / 100;
    
    axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
    
    hold on;
	
    
    %%% For each caracteristic plot them. Each class have a different color and each file a
    %   different line.
    
    for iClass = 1 : nClasses,
        for iFile = fileIdxPerClassCAr{iClass},    
            
            plot(allObsArr(iFile, :, iCar), iFile*ones(1, nObsPerFile), [colArr(iClass), classTagStr(iClass)]);
            
        end
    end
    
    axis tight;
    ylim([0, nFiles + 1]);
    
end


%%% Plot all caracteristics so one can compare the diversity between all classes.

for iCar = 1 : nCarKept,
    
    
    %%% Build axes
   
    axesXPos = ((iCar-1)*(100/nCarKept) + 1.5 ) / 100;
    axesYPos = (20) / 100;
    axesW    = (100/nCarKept - 2) / 100; 
    axesH    = 12 / 100;
    
    axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
    
    hold on;
    
    
    %%% Compute usefull data for gaussian estimation of each class
    
    carRange = [min(min(min(allObsArr(:, :, iCar)))), ...
                    max(max(max(allObsArr(:, :, iCar))))];
    nGauss   = carRange(1) : (carRange(2)-carRange(1))/10000 : carRange(2);
                
    
    %%% Bloc all caracteristics. One different line for each class. Plot the gaussian estimation of
    %   each class over each data class.
    
    for iClass = 1 : nClasses,
        
        % Extract caracteristcs for this class
        carForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iCar);
        carForThisClassVec = carForThisClassArr(:);
        
        % Compute gaussian parameters estimation
        mean1Vec = nanmean(carForThisClassVec);
        std1  = nanstd(carForThisClassVec);
        
        % Build gaussian estimation
        pdf1 = normpdf(nGauss, mean1Vec, std1);
        pdf1 = pdf1/max(pdf1);
        
        % Plot
        plot(carForThisClassVec, iClass*ones(1, nObsPerClassArr(iClass)), [colArr(iClass), classTagStr(iClass)]);
        plot(nGauss, pdf1 + iClass, colArr(iClass));
        
    end
    
    axis tight;
    ylim([0, nClasses + 1.1]);
    title(carKeptNameCAr{iCar});

end



%%% Plot caracteristics histogram for each class.

for iCar = 1 : nCarKept,
    
    
    %%% Build axes
   
    axesXPos = ((iCar-1)*(100/nCarKept) + 1.5 ) / 100;
    axesYPos = (2) / 100;
    axesW    = (100/nCarKept - 2) / 100; 
    axesH    = 12 / 100;
    
    axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
    
    hold on;
    
    
    %%% Compute usefull data for gaussian estimation of each class
    
    carRange = [min(min(min(allObsArr(:, :, iCar)))), ...
                    max(max(max(allObsArr(:, :, iCar))))];
    nGauss   = carRange(1) : (carRange(2)-carRange(1))/10000 : carRange(2);
                
    
    %%% Bloc all caracteristics. One different line for each class. Plot the gaussian estimation of
    %   each class over each data class.
    
    maxHistY = 0;
    histBinWidth = 0;
    for iClass = 1 : nClasses,
        
        % Extract caracteristcs for this class
        carForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iCar);
        carForThisClassVec = carForThisClassArr(:);
        
        % Compute nBins
        carDyn = max(carForThisClassVec) - min(carForThisClassVec);
        if iClass == 1,
            histBinWidth = carDyn / 100;
        end
        nHistBin = carDyn / histBinWidth;
        
        % Compute histogram
        [histY, histX] = hist(carForThisClassVec, nHistBin);
        histX(histY == 0) = [];
        histY(histY == 0) = [];
        
        % Plot
        h = stem(histX, histY, colArr(iClass), 'MarkerFaceColor', colArr(iClass), 'Marker', histMarkerStr(iClass));
        maxHistY = max([histY, maxHistY]);
    end
    
    axis tight;
    ylim([0, maxHistY]);
    title('Histogram')

end



%% Clean environment


% eof
