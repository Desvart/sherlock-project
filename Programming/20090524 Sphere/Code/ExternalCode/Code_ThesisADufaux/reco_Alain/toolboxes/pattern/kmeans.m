function [mem,mout] = kmeans( x, K )
%KMEANS		K-Means clustering algorithm
%
%Usage:		[MEM,M] = KMEANS( X, K )
%		[MEM,M] = KMEANS( X, Z )
%
%	This function implements the K-means cluster algorithm.  X is
%	the MxN data matrix, where M is the number of dimensions and N
%	is the number of vectors.  X may contain complex data.
%
%	If the second argument is a scalar, then it is intepreted as
%	K -- the number of desired clusters.
%
%	The second argument can also be interpreted as Z -- the initial
%	estimate of the cluster centres, and the number of clusters is
%	inferred from the size of Z.  In this case Z is a KxM matrix.
%
%	A row vector associating each sample with one of the K classes
%	is returned in MEM, as well, the final estimates of the means in M.
%	If a cluster in Z is not represented by at least one vector in X,
%	then the original estimate of the mean for that cluster is returned.

%       (c) Copyright 1995-1996 by Dave Caughey.  All rights reserved.

[M,N] = size(x);	% #dimension x #vectors

% Prepare the data -- if complex, convert to 2*M dimensionality
if ~isreal( x ),
    x2 = zeros(size(x).*[2 1]);
    x2((1:M)*2-1,:) = real(x);
    x2((1:M)*2  ,:) = imag(x);
    x = x2;
    M = 2*M;
end;

% Step 1: choose K initial cluster centres.
if nargin == 2,
    if prod(size(K)) == 1,
	m = x(:,1:K)';
    else
        m = K;
	K = size(m,1);
    end;
else
    help kmeans
    return;
end;

mnew = zeros(size(m));
while ( 1 ),

% Step 2: distribute the samples amongst K cluster domains (Euclid distance)
    d = zeros(K,N);
    for i = 1:K,
	mz = (ones(N,1)*m(i,:))';
	d(i,:) = sum((x-mz).^2);
    end;
    [dummy,mem] = min(d);	% membership determined by min distance

% Step 3: compute new cluster centres
    for i = 1:K,
	if sum(mem==i) == 0,
	    mnew(i,:) = m(i,:);
	elseif sum(mem==i) == 1,
	    mnew(i,:) = x(:,mem==i)';
	else
	    mnew(i,:) = mean(x(:,mem==i)');
	end;
    end;

% Step 4: check stopping criteria
    if all((mnew(:)-m(:))==0),
	break;
    else
	m = mnew;
    end;
end;
if nargout == 2,
    mout = m;
end;
