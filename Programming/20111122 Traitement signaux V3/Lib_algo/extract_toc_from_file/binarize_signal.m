

function binarizedSignal = binarize_signal(signal, threshold)
%
% Project TicLoc : Alpha 0.0.7 - 2011.03.30

    binarizedSignal = zeros(1, length(signal));
    binarizedSignal(signal>threshold) = 1;
    
end