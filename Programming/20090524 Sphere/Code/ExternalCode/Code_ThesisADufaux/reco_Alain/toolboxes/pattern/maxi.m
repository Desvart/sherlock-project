function index = maxi(x)
%MAXI		Index of largest component
%
%Usage:		INDEX = MAXI(X)
%	This function returns the index of the maximum element of X,
%	as defined by the built-in MAX command.
%
%	See also MAX

%Copyright (c) 1993-1995 by Ahlea Systems Corp.  All rights reserved.

[dummy index] = max(x);
