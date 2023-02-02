function nSavedToc = save_toc(toc, fs, tocPathDir, nSavedToc)
        
    nToc = size(toc, 1);
    for iToc2 = 1:nToc/2,
        
        ticFilePath = [tocPathDir, 'toc1_', sprintf('%04d', nSavedToc+iToc2), '.wav'];
        tacFilePath = [tocPathDir, 'toc2_', sprintf('%04d', nSavedToc+iToc2), '.wav'];
 
        tic = toc(2*(iToc2-1)+1, :);
        tic(isnan(tic)) = [];
        wavwrite(tic, fs, 32, ticFilePath);
        
        tac = toc(2*(iToc2), :);
        tac(isnan(tac)) = [];
        wavwrite(tac, fs, 32, tacFilePath);

    end    
    
    nSavedToc = nSavedToc + iToc2;
    
end