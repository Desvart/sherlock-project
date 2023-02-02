function [v,d,cx] = coveig( x )
%COVEIG		Perform eigenanalysis on the covariance matrix of a data set
%
%Usage:		[V,D,CX] = COVEIG( X )
%
%	This function performs eigenanalysis on a matrix of feature vectors X.
%
%	The eigenvectors V and eigenvalues D are returned sorted by descending
%	eigenvalue.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
cx = cov(x');
[v,d] = eig(cx);
du=diag(d);
[d di] = sort(-du);d=-d;v=v(:,di);
