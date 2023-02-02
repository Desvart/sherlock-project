function searchButton_callback(hSource, eventdata)
    
    handles    = guihandles;
    folderPath = [uigetdir('./', 'Select a data folder to analyse...'), '\'];
    set(handles.pathField, 'String', folderPath);
    
    init_gui_A1(true);
end
