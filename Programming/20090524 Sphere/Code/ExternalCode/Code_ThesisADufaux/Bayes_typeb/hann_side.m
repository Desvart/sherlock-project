% **********************************************************************
% File to build a flat window with hann-shaped sides on overlapped parts 
% **********************************************************************

function W = hann_side(L, overlap)


% Build Hann window with size = 2*overlap
h = hann(2*overlap,'periodic');

% Build Window with size L
W = boxcar(L);

% Modify Raising side
W(1:overlap) = h(1:overlap);

% Modify Decay side
W(L-overlap+1 : L) = h(overlap+1 : 2*overlap);
