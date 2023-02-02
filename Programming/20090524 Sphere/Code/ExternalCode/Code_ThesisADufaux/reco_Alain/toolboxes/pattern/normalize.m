function [y,mx,cx] = normalize( x )
%NORMALIZE	Normalize data set to zero-mean, unit-variance
%
%Usage:		Y = NORMALIZE( X )
%		[Y,M,C] = NORMALIZE( X )
%
%	This function normalizes an M-dimensional distribution such that
%	it is zero-mean, unit variance.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
[v,d,cx] = coveig(x);
mx = mean(x')';
y = reduce( x-mx*ones(1,size(x,2)), v, d, length(d) );
