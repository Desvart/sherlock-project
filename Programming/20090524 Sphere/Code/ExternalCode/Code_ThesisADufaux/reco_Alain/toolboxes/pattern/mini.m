function index = mini(x)
%MINI		Index of smallest component
%
%Usage:		INDEX = MINI(X)
%	This function returns the index of the minimum element of X,
%	as defined by the built-in MIN command.
%
%	See also MIN

%Copyright (c) 1993-1995 by Ahlea Systems Corp.  All rights reserved.

[dummy index] = min(x);
