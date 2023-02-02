function [mainFigurePosition, isMonoMonitor] = shh_initialize_viso_gui(monitor_position_correction, ...
                                                                       database_default_fullpath, ...
                                                                       name_of_selected_acquisition)
    %
    %
    %
    
    %
    
                                                                   
    
    %% Determine main figure position
    
    set(0, 'Units', 'pixels'); % Set the working unit for elements positionning

    monitorPositionArray = get(0, 'MonitorPositions');    % Get monitors size and position
    nMonitor             = size(monitorPositionArray, 1); % Extract number of screen used
    isMonoMonitor        = nMonitor == 1;

    if isMonoMonitor == true, % if there is only one monitor
        mainFigurePosition    = monitorPositionArray(1, :);
        mainFigurePosition    = mainFigurePosition - monitor_position_correction(1, :); % Small correction to correctly display figure borders. 

    else % if there is more than one monitor 
        mainFigurePosition    = monitorPositionArray(2, :);                                    % Extract position of second monitor
        mainFigurePosition(3) = mainFigurePosition(3) - monitorPositionArray(1, 3);            % Compute size of second monitor
        mainFigurePosition    = mainFigurePosition    - monitor_position_correction(2, :); % Small correction to correctly display figure borders
    end

    
    
    %% Verify if selected acquisition data exist and if so, load them.
    
    videoFullPath    = [database_default_fullpath, name_of_selected_acquisition, '.mp4'];
    soundFullPath    = [database_default_fullpath, name_of_selected_acquisition, '.mat'];
    metadataFullPath = [database_default_fullpath, name_of_selected_acquisition, '_metadata.mat'];
    
    % Load metadata
    if exist(metadataFullPath, 'file') == true,
        shh_load_metadata(metadataFullPath);
    else
        error('Metadata file (''%s'') does not exist.', metadataFullPath);
    end
    
    % Load sound data
    if exist(soundFullPath, 'file') == true,
        shh_load_sound(soundFullPath);
    else
        error('Sound file (''%s'') does not exist.', soundFullPath);
    end
    
    % Load video data
    if exist(videoFullPath, 'file') == true,
        shh_load_video(videoFullPath);
    else
        error('Video file (''%s'') does not exist.', videoFullPath);
    end
    
    
end



function shh_load_metadata(metadataFullPath)

    Data = guidata(gcf);
    
    MetadataObj           = matfile(metadataFullPath);
    Data.firstTocIdxArray = MetadataObj.firstStartTocIdxArray;
    Data.lastTocIdxArray  = MetadataObj.lastTocIdxArray;
    Data.nTocs            = MetadataObj.nTocs;
    Data.partner          = MetadataObj.partner;
    Data.calibre          = MetadataObj.calibre;
    Data.pointage         = MetadataObj.pointage;
    Data.fps              = MetadataObj.fps;
    
    guidata(gcf, Data);
   
end



function shh_load_sound(soundFullPath)

    Data = guidata(gcf);
    
    Data.SoundObj   = matfile(soundFullPath);
    Data.fs         = Data.SoundObj.fs;
    Data.nSamples   = size(Data.SoundObj, 'signal', 2);
    Data.normFactor = Data.SoundObj.normFactor;
    
    guidata(gcf, Data);
   
end



function shh_load_video(videoFullPath)

    Data = guidata(gcf);
    
    Data.VideoObj = VideoReader(videoFullPath);
    Data.nFrames  = VideoObj.NumberOfFrames;
    
    guidata(gcf, Data);
   
end


% eof
