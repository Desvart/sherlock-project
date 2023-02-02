function blockId = determine_block_decomposition_index(watchPath, distanceInterToc, nTocPerFrame, signalFirstCleanId)
%
% Project TicLoc: A0.1.1
% Author: Pitch Corp.  -  2011.05.10  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Extract signal size
    sSignal = wavread(watchPath, 'size');

    % --- First index (half location between toc 1 and 2)
    sSignal = sSignal(1) - signalFirstCleanId + 1;

    % --- Compute number of block that can be done
    sBlock   = (nTocPerFrame+1) * distanceInterToc;   
    sOverlap = distanceInterToc;
    sFrame = sBlock - sOverlap;
    nBlock = floor(sSignal / sFrame);

    % --- Compute block index (first and last)
    blockId = zeros(2, nBlock);                 % Preallocation
    blockId(1, 1) = signalFirstCleanId;         % Init
    blockId(2, 1) = blockId(1, 1) + sBlock - 1; % Init
    for iBlock = 2:nBlock,
        
        blockId(1, iBlock) = blockId(2, iBlock-1) - sOverlap + 1;
        blockId(2, iBlock) = min(blockId(1, iBlock) + sBlock - 1, sSignal + signalFirstCleanId - 1);
        
    end

end