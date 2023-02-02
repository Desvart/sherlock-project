function metadata_generator

close all;
clear all;
clc;

PROJECT_ROOT_FULLPATH        = '.\\Ongoing\ABP011_Sherlock_Holmes\';
DATABASE_ROOT_FULLPATH       = [PROJECT_ROOT_FULLPATH, 'Data\Videos\ViSo\'];
DATABASE_DEFAULT_FULLPATH    = [DATABASE_ROOT_FULLPATH, 'ViSo_2_0\ML_Influence_du_barillet\'];
NAME_OF_SELECTED_ACQUISITION = 'ML01_R00_B06_N01';
TEXT_IMAGE_PXL_POSITION_X    = {8:20; 8:20; 8:20};
TEXT_IMAGE_PXL_POSITION_Y    = {6:70; 6:70; 204:246}; % First frame, last frame, fps
FIGURE_POSITION_OFFSET       = [-8, -8, 15, 37];
OCR_MODEL_FILE               = 'digitTemplates_2.mat';
PLOT_MARGIN                  = [5, 0, 0, 0] / 100; % yd, yu, xl, xr


%% Initialize script

%%% Build main path
[videoFullPath, soundFullPath] = init_path(DATABASE_DEFAULT_FULLPATH, NAME_OF_SELECTED_ACQUISITION);

%%% Compute figure positions
set(0, 'Units', 'pixels'); % Set the working unit for elements positionning
figurePositionArray = compute_figure_positions(FIGURE_POSITION_OFFSET);

%%% Load video
[VideoObj, nFrames, firstFrameImage, lastFrameImage] = load_video(videoFullPath);

%%% Load sound
[SoundObj, signal, fs] = load_sound(soundFullPath);



%% Perform OCR on first and last frame to extract frame index delimiters and fps.

%%%
imageCellArray = text_image_extraction(firstFrameImage, lastFrameImage, ...
                                       TEXT_IMAGE_PXL_POSITION_X, TEXT_IMAGE_PXL_POSITION_Y);
                  
%%%
ocrResultArray = ocr_process(imageCellArray, OCR_MODEL_FILE);



%% Locate tocs

tocPositionArray = detect_toc_position(signal);



%% Display metadata extracted

%%% Plot OCRed images
plot_ocr_results(figurePositionArray, imageCellArray, ocrResultArray);

%%% Plot extracted tocs
plot_extracted_tocs(figurePositionArray, PLOT_MARGIN, signal, tocPositionArray);

 
 
% plot(abs(signal));
% axis tight;
% ylim([-0.04, 1]);
% 
% magnifyOnFigure(hFig, 'units', 'pixels', ...
%                       'initialPositionSecondaryAxes', [(soundFigurePosition(3)-1600)/2, soundFigurePosition(4)/2, 1600, 200], ...
%                       'initialPositionMagnifier',     [1 1 20 100], ...    
%                       'mode', 'interactive', ...
%                       'displayLinkStyle', 'straight', ...
%                       'edgeColor', 'red', ...
%                       'secondaryAxesFaceColor', [0.91 0.91 0.91]); 

% keyboard
% 
% magnify on figure
% tight subplot
% 
% dcm_obj = datacursormode(gcf); 
% info_struct = getCursorInfo(dcm_obj); 
% a = [info_struct.Position]; 
% disp(a(1:2:end)');
% dc          = [dc, a(1:2:end)'];      %#ok<AGROW>

% 
% dc                      = sort(dc);
% 
% tocFirstIdxArray        = dc(1:4:end);
% tocLastIdxArray         = dc(4:4:end);
% impulsionFirstIdxArray  = dc(2:4:end);
% chuteFirstIdxArray      = dc(3:4:end);
% nTocs                   = length(tocFirstIdxArray);
mvtFrequency            = 0;
partner                 = 0;
calibre                 = 0;
pointage                = 0;
fps                     = 0;
firstFrameOffset        = 0;
last                    = 0;

end



function [videoFullPath, soundFullPath] = init_path(databaseDefaultFullpath, nameOfSelectedAcquisition)
    videoFullPath = [databaseDefaultFullpath, nameOfSelectedAcquisition, '.mp4'];
    soundFullPath = [databaseDefaultFullpath, nameOfSelectedAcquisition, '.mat'];
end



function figurePositionArray = compute_figure_positions(figurePositionOffset)
    monitorPositionArray  = get(0, 'MonitorPositions');                         % Get monitors size and position
    mainFigurePosition    = monitorPositionArray(2, :);                         % Extract position of second monitor
    mainFigurePosition(3) = mainFigurePosition(3) - monitorPositionArray(1, 3); % Compute size of second monitor

    figurePositionArray       = zeros(4, 4);
    figurePositionArray(1, :) = mainFigurePosition .* [1/1, mainFigurePosition(4)*2/3, 1/3, 1/3] - figurePositionOffset;
    figurePositionArray(2, :) = mainFigurePosition .* [4/3, mainFigurePosition(4)*2/3, 1/3, 1/3] - figurePositionOffset;
    figurePositionArray(3, :) = mainFigurePosition .* [5/3, mainFigurePosition(4)*2/3, 1/3, 1/3] - figurePositionOffset;
    figurePositionArray(4, :) = mainFigurePosition .* [1/1,                       1/1, 1/1, 2/3] - figurePositionOffset;
end



function [VideoObj, nFrames, firstFrameImage, lastFrameImage] = load_video(videoFullPath)
    VideoObj        = VideoReader(videoFullPath);
    nFrames         = VideoObj.NumberOfFrames;
    firstFrameImage = read(VideoObj, 1);
    lastFrameImage  = read(VideoObj, nFrames);
end



function [SoundObj, signal, fs] = load_sound(soundFullPath)
    SoundObj = matfile(soundFullPath);
    signal   = SoundObj.signal;
    fs       = SoundObj.fs;
end



function imageCellArray = text_image_extraction(firstFrameImage,  lastFrameImage, ...
                                                textImagePxlPositionXArray, textImagePxlPositionYArray)
	imageCellArray = cell(3, 1);
    for iImage = [1, 3],
        imageCellArray{iImage} = imcomplement(firstFrameImage(textImagePxlPositionXArray{iImage}, ...
                                                              textImagePxlPositionYArray{iImage}, 1));
    end
    imageCellArray{2} = imcomplement(lastFrameImage(textImagePxlPositionXArray{2}, ...
                                                              textImagePxlPositionYArray{2}, 1));
end



function ocrResultArray = ocr_process(imageCellArray, ocrModelFile)
    ocrResultArray = zeros(3, 1);
    for iImage = 1 : 3,
        ocrResultArray(iImage) = integer_ocr(imageCellArray{iImage}, ocrModelFile);    
    end
end



function plot_ocr_results(figurePositionArray, imageCellArray, ocrResultArray)
    titleStringArray = {'First frame index'; 'Last frame index'; 'Video fps'};
    for iPlot = 1 : 3,
        figure('Position', figurePositionArray(iPlot, :), 'Menu', 'none');
        image(imageCellArray{iPlot});
        colormap('gray') 
        axis off;
        axis image;
        title(sprintf([titleStringArray{iPlot}, ' (OCRed : %d)'], ocrResultArray(iPlot)));
    end
end 


function plot_ocr_results_2(figurePositionArray, imageCellArray, ocrResultArray)
    figure('Position', [1921, 1, 1920, 1004]);
    
    axes('Units',      'normalized', ...
         'Position',   [0, 80, 30, 17]/100);
    image(imageCellArray{1});
    set(gca, 'XTickLabel', '', 'YTickLabel', '');
    colormap('gray') 
% 	axis off;
    title('1');
     
    axes('Units',       'normalized', ...
         'Position',    [35, 80, 30, 17]/100);
	image(imageCellArray{2});
    colormap('gray') 
	axis off;
    title('2');
    
    axes('Units',       'normalized', ...
         'Position',    [70, 80, 30, 17]/100);
    image(imageCellArray{3});
    colormap('gray') 
	axis off;
    title('3');
    
    axes('Units',       'normalized', ...
         'Position',    [0, 2, 100, 77]/100);
     
     plot(rand(60,1));

 [magnifierHandle, zoomAxesHandle] = magnifyOnFigure2(gca, ...
            'units',                        'pixels', ...
            'initialPositionSecondaryAxes', [(figurePositionArray(4, 3)-1600)/2, figurePositionArray(4, 4)/2, 1600, 200], ...
            'initialPositionMagnifier',     [210, 30, 20, 100], ...
            'mode',                         'interactive', ...
            'displayLinkStyle',             'none', ...
            'edgeColor',                    'red', ...
            'secondaryAxesFaceColor',       [0.91, 0.91, 0.91]);
end 


function plot_extracted_tocs(figurePositionArray, plotMargin, signal, tocPositionArray)
    hFig = figure('Position', figurePositionArray(4, :), 'Color', 'white');
    
    verticalMargin   = plotMargin(1:2);
    horizontalMargin = plotMargin(3:4);
    axh              = 1 - sum(verticalMargin);
    axw              = 1 - sum(horizontalMargin);
    py               = 1 - verticalMargin(2) - axh;
    px               = horizontalMargin(1);
    axes('Units',       'normalized', ...
         'Position',    [px, py, axw, axh], ...
         'XTickLabel',  '', ...
         'YTickLabel',  '');
	hold on;


    nSamples = length(signal);
%     disp(nSamples/fs);

% 15180 - 23510
    
    
    plot(abs(signal)); 
    plot(40, abs(signal(40)), '*r');
    
    axis tight;
    ylim([-0.04, 1]);
    
    %%% Determine la position du zoom en pixel (par rapport � la position d�finie dans les
    %%% coordonn�es de l'axe (au sens Matlab du terme)
%     set(gca,'units','pixels');
%     pos = get(gca,'position');
%     xlim = get(gca,'xlim');
%     ylim = get(gca,'ylim');
% 
%     a = get(gcf,'position');
%     x_in_axes = 15180;
%     x_in_pixels = pos(3) * (x_in_axes-xlim(1))/(xlim(2)-xlim(1));


    magnifyOnFigure2(hFig, ...
            'units',                        'pixels', ...
            'initialPositionSecondaryAxes', [(figurePositionArray(4, 3)-1600)/2, figurePositionArray(4, 4)/2, 1600, 200], ...
            'initialPositionMagnifier',     [210, 1, 20, 100], ...
            'mode',                         'interactive', ...
            'displayLinkStyle',             'straight', ...
            'edgeColor',                    'red', ...
            'secondaryAxesFaceColor',       [0.91, 0.91, 0.91]);
end

% eof
