function waitbar_Update(h, crossId, nbCrossvalidation)
    
    waitbar_Label = ['Iteration : ', int2str(crossId), '/', int2str(nbCrossvalidation)];
    waitbar(crossId/nbCrossvalidation, h, waitbar_Label);
    
end
