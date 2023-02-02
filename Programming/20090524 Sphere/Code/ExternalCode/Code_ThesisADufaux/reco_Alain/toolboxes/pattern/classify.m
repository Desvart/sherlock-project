function [member, dg] = classify( x, m, c, pwi )
%CLASSIFY	Associate feature vectors with Gaussian-distributed classes
%
%Usage: 	MEMBER = CLASSIFY( X, M, C [,PWI] )
%
%	This function performs Gaussian classification on the data X
%	described by their means M and covariance matrices C.  Results
%	are returned as a vector of memberships. One can pass in an
%	option array of the class probabilities.

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.
if nargin == 3
    dg = dbayes( x, m, c );
elseif nargin == 4
    dg = dbayes( x, m, c, pwi );
else
    help classify
    return
end;
member = mini([dg;Inf*ones(1,size(dg,2))]);
