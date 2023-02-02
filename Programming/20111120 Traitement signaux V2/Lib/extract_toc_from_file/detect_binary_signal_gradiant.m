
function [borderFirstId, borderLastId, nBorder] = detect_binary_signal_gradiant(binarizedSignal)
%
% Project TicLoc : Alpha 0.0.7 - 2011.03.30

    nSignalPad = length(binarizedSignal);
    
    % --- Determine borders of "blobs".
    border = binarizedSignal(2:end) - binarizedSignal(1:end-1);
    
    % --- Determine "blobs" first and last localization.
    borderFirstId = find(border == +1);
    borderLastId  = find(border == -1);
    
    % --- If first or last blob is cut, adapt first or last Id to signal size
    if length(borderFirstId) ~= length(borderLastId),
        if borderLastId(1) < borderFirstId(1),
            borderFirstId = [1, borderFirstId];
        end
        if borderFirstId(end) > borderLastId(end),
            borderLastId = [borderLastId, nSignalPad];
        end
    end
    
    nBorder = length(borderFirstId);
    
end

