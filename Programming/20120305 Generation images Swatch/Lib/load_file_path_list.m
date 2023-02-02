function [filePathList, nFileTot, fileNameAll] = load_file_path_list(folderPath)


    %%% Process string to have a standard way of reprensenting a path './xxxx/yyyy/'
    
    % If string contains back-slashes convert them in simple slashes.
    findChar = strfind(folderPath, '\');
    if findChar,
        folderPath(findChar) = '/';
    end
    
    % If there is no slash at the end of the folder path, add one.
    if ~strcmp(folderPath(end), '/'),
        folderPath = [folderPath, '/'];
    end

    
    %%%
    [nFolder, folderName] = extract_folder_inventory(folderPath, true);
    
    
    %%%
    nFileTot = 0;
    nFilePerFolder = zeros(nFolder, 1);
    for iFolder = 1 : nFolder,
        nFilePerFolder(iFolder) = extract_folder_inventory([folderPath, '/', folderName{iFolder}], true);
        nFileTot = nFileTot + nFilePerFolder(iFolder);
    end
    
    fileNameAll = cell(nFileTot, 1);
    fileAbsId = 1;
    for iFolder = 1 : nFolder,
        [nFile, fileName] = extract_folder_inventory([folderPath, '/', folderName{iFolder}]);
        fileNameAll(fileAbsId:fileAbsId+nFile-1) = fileName;
        fileAbsId = fileAbsId + nFile;
    end
    
    filePathList = cell(nFileTot, 1);
    for iFile = 1:nFileTot,
        filePathList{iFile} = [folderPath, '/', fileNameAll{iFile}];
    end
    
end
