function e=certain( x, m, c, pw );
%CERTAIN 	Calculate the certainties of classifications
%
%Usage:		E=CERTAIN( X, M, C [,PW] )
%
%	Calculate the certainties of classification for each point in X
%	given the stats M and C.
%
%	A row vector will be returned where each element corresponds to
%	the certainty for the appropriate classification.
%
%	The certainty is a number 0 < e <= 1, where the probabilities
%	have been scaled to the minimum of 0.5 or the lowest classified
%	certainty.
%
%	See also fuzzclassify

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.
[K M] = size(m);
if nargin == 3,
    pw = ones(K,1)/K;
end;

fuzz = fuzzclassify( x, m, c, pw );
mem=classify( x, m, c );
efuzz = fuzz((0:(size(x,2)-1))*K+mem);

Kf = min(.5,min(efuzz)-.01);
e = (efuzz-Kf)/(1-Kf);
