function loadButton_callback(hSource, eventdata)

    Handles    = guihandles;
    folderPath = get(Handles.pathField, 'String');
    if ~isdir(folderPath),
        folderPath = uigetdir('./', 'Select a data set folder to work on...');
        set(Handles.pathField, 'String', [folderPath, '\']);
    end
    
    init_gui_A2(true);
    
end
