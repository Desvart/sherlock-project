function fuzz=fuzzclassify( x, m, c, pw );
%FUZZCALC 	Calculate the certainties of classifications
%
%Usage:		E=FUZZCLASSIFY( X, M, C [,PW] )
%
%	Calculate the certainties of classification for each point in X
%	given the stats M and C.
%
%	The class probabilities PW are assumed uniform if not specified.
%
%	See also certain.

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.

[K M] = size(m);
if nargin == 3,
    pw = ones(K,1)/K;
end;

p = likelihood( x, m, c, pw );
psumx = sum(p);
fuzz = (p./(ones(K,1)*psumx));
