function toc = extract_and_concatenate_toc_from_block(signal, nLongestTocPad, tocFineLocation, distanceInterToc, nToc)
%
% Project TicLoc : Alpha 0.0.8 - 2011.04.07

    toc = nan(nToc-1, nLongestTocPad);
    offset = round(distanceInterToc/10);
    for iToc = 1:nToc-1,
        
        thisTocDuration = tocFineLocation(1, iToc+1) - tocFineLocation(1, iToc);
        thisTocId = (tocFineLocation(1, iToc):tocFineLocation(1, iToc+1)-1) - offset;
        toc(iToc, 1:thisTocDuration) = signal(thisTocId);
        
    end

end