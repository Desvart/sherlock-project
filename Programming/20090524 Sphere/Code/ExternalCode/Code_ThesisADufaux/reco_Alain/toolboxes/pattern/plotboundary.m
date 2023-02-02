function plotboundary( arg1, arg2, arg3, arg4, arg5, arg6 )
%PLOTBOUNDARY	Calculate and plot the boundaries between Gaussian classes
%
%Usage:		PLOTBOUNDARY( M, C [,P] [,T] [,L1,L2] );
%
%	This function plots the boundaries between the classes defined
%	by their multi-class means M and covariances C.
%
%	T is an optional number (default 200) of ticks used to generate
%	the curves.  A higher value of T yields better intersections,
%	but takes longer.  L1 and L2 are the primary and secondary
%	boundary linestyles (either both or none must be specified,
%	although one or both may be an empty string).
%
%	P are the class probabilities.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
T = 200;
linestyle1 = '-';
linestyle2 = [];
pwi = [];
if nargin == 0,
    help plotboundary
    return
else
    argi = 1;
    while argi <= nargin,
	eval( sprintf( 'arg = arg%d;', argi ) );
	if isstr( arg ), 		% is string (must be L1/L2)
	    eval( sprintf( 'linestyle1 = arg%d;', argi ) )
	    eval( sprintf( 'linestyle2 = arg%d;', argi+1 ) )
	    argi = argi+2;
	elseif size( arg ) == [1 1], 	% is scalar (must be T)
	    eval( sprintf( 'T = arg%d;', argi ) );
	    argi = argi+1;
	elseif min(size(arg)) == 1,	% if vector, must be probabilities
	    pwi = arg;
	    argi = argi+1;
	else				% if matrix, must be means/covariances
	    m = arg;
	    eval( sprintf( 'c = arg%d;', argi+1 ) );
	    argi = argi+2;
	end;
    end;
end;

K = size(m,1);
M = size(m,2);
if isempty( pwi ),
    pwi = ones(1,K)/K;
end;

mix = zeros( 1, K );
for i = 1:K,
    mix(i)  = det(reshape(c(i,:),M,M));
end;

[dummy mi] = sort(mix);

%
% Generate the borders between class pairs
%
for i = 1:K-1,
    for j = (i+1):K,
	xp = boundary( m(mi(i),:)', reshape(c(mi(i),:),M,M), ...
			m(mi(j),:)', reshape(c(mi(j),:),M,M), ...
			pwi(mi(i)), pwi(mi(j)), T );
	cmd = sprintf( 'xp%d%d=xp;', min(mi(i),mi(j)), max(mi(i),mi(j)) );
	eval( cmd );
    end;
end;

%
% Plot the relevant points
%
for i = 1:K-1,
    for j = (i+1):K,
	cmd = sprintf( 'xp = xp%d%d;', min(mi(i),mi(j)), max(mi(i),mi(j)) );
	eval(cmd);
	if ~isempty( linestyle2 ),
	    plot( xp(1,:), xp(2,:), linestyle2 );
	end;
	for k = 1:K,
	    xd = xp-m(i,:)'*ones(1,size(xp,2));
	end;
	xpd = dbayes(xp,m,c,pwi);
	%if sum(isnan(xp(1,:)))==1,
	    %strt = 1;
	    %xp = xp(:,1:size(xp,2)-1);
	%else
	    %strt = 0;
	%end;
	member = mini(xpd);
	y = find(member == mi(i) | member == mi(j));
	if ~isempty( y ) & ~isempty( linestyle1 ),
	    z = find(diff(y)>1);
	    if isempty( z ),
		plot( xp(1,y), xp(2,y), linestyle1 );
	    else
		ymins = [min(y) y(z+1)-1];
		ymaxs = [y(z)+1 max(y)];
		for k = 1:length(z)+1,
		    r = ymins(k):ymaxs(k);
		    %if k == length(z) + 1 & ymaxs(k) == size(xp,2) & strt==0,
		    if k == length(z) + 1 & ymaxs(k) == size(xp,2)
			r = [r 1];
		    end;
		    plot( xp(1,r), xp(2,r), linestyle1 );
		end;
	    end;
	end;
    end;
end;
