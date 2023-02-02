function update_file_selection_fields(folderPath)

    [nFolder, folderName] = extract_folder_inventory(folderPath, true);
    
    nFileTot = 0;
    nFilePerFolder = zeros(nFolder, 1);
    for iFolder = 1 : nFolder,
        nFilePerFolder(iFolder) = extract_folder_inventory([folderPath, '\', folderName{iFolder}], true);
        nFileTot = nFileTot + nFilePerFolder(iFolder);
    end
    
    fileNameAll = cell(nFileTot, 1);
    fileAbsId = 1;
    for iFolder = 1 : nFolder,
        [nFile, fileName] = extract_folder_inventory([folderPath, '\', folderName{iFolder}]);
        fileNameAll(fileAbsId:fileAbsId+nFile-1) = fileName;
        fileAbsId = fileAbsId + nFile;
    end
    
    set(findobj('tag', 'fileList'), 'String', fileNameAll);
    
end