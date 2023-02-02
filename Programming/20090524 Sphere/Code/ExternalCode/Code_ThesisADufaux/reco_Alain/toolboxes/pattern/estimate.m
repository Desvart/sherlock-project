function [m,c] = estimate( x, member )
%ESTIMATE	Estimate the statistics of data sets
%
%Usage:		[M,C] = ESTIMATE( X, MEMBERSHIP )
%
%	This function performs estimates the means and covariances
%	of the column vectors of X for the classes defined by MEMBER.
%	
%	The results of class i are return as rows within the M and C
%	matrices.  The covariance has been RESHAPED to a 1x(m^2) vector.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
M = size(x,1);
K = max( member );
for i = 1:K,
    y = find(member==i);
    if ( length(y) == 0 ),
	fprintf( 'estimate: class %d contains no data!  Estimates set to NaN\n', i);
	m(i,:) = NaN*ones(1,M);
	c(i,:) = NaN*ones(1,M^2);
    elseif length(y) == 1,
	fprintf( 'estimate: class %d contains one vector!\n', i );
	m(i,:) = x(:,y)';
	c(i,:) = zeros(1,M^2);
    else
	if length(y) <= M,
	fprintf( 'estimate: class %d contains %d vectors in %d dimensions!\n', i, length(y), M );
	end;
	m(i,:) = mean(x(:,y)');
	c(i,:) = reshape( cov(x(:,y)'), 1, M^2 );
    end
end;
