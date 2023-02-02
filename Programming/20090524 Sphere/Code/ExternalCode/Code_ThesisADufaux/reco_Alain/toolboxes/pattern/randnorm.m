function [x,mem] = randnorm( n, m, c );
%RANDNORM	Generate some Gaussian data for mulit-class lists of statistics
%
%Usage:		[X,MEMBER]=RANDNORM( N, M, C )
%
%	This function generates normally distributed points such the data
%	have the stats defined by the mean and covariance matrices M and C.
%
%	If M and C are multi-class descriptors, then N points are generated
%	for each class, (unless N is a vector of sizes).
%
%	The data are returned in X, with the membership in MEMBER.

%       (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.

[K,M] = size(m);
mem = [];
if M == 1,
    % could be K one-dimensional classes, or a single K-dimensional class
    if size(c,1) == K,
        % interpret K as # of classes, therefore it must be 1-D classes
	if size(c,2) ~= 1,
	    fprintf( 'randnorm: dimension mismatch between M and C\n' );
	    return;
	end;
    else 
        M = K;
	K = 1;
	if any( size(c,1) ~= [M M] ), 
	    fprintf( 'randnorm: dimension mismatch between M and C\n' );
	    return;
	end;
	m = m';
	c = reshape(c,1,M^M);
    end;
else
    if size(c,2) ~= M^2,
	fprintf( 'randnorm: dimension mismatch between M and C\n' );
        return;
    elseif size(c,1) ~= K,
	fprintf( 'randnorm: # classes mismatch between M and C\n' );
        return;
    end;
end;

%
% Now, generate the data, using the concept that 
%    y = v*sqrt(d)*x + m
%    C = E{(y-m)*(y-m)'}
%      = E{v*sqrt(d)*x*x'*sqrt(d)'*v'}
%      = v*sqrt(d)*E{x*x'}*sqrt(d)'*v'
%      = v*sqrt(d)*I*sqrt(d)'*v'
%      = v*d*v'
%

if prod(size(n))==1,
    n = n(ones(1,K));
end;

x = zeros(sum(n),M);
for i = 1:K,
    cx = reshape(c(i,:),M,M);
    [v d] = eig(cx);
    x(sum(n(1:(i-1)))+(1:n(i)),:) = (v*sqrt(d)*randn(M,n(i)))'+m(i*ones(1,n(i)),:);
    mem = [mem i*ones(1,n(i))];
end;
x = x';
