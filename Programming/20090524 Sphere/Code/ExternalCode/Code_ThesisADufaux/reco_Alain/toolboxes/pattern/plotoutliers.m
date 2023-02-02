function hout=plotoutliers( m, c, arg1, arg2, arg3 )
%PLOTOUTLIERS	Plot outliers boundaries
%
%Usage:		H=PLOTOUTLIERS( M, C [,MEMBER] [,D] [,LINESTYLE] )
%
%	This function plots the boundaries which define the outliers (given
%	by the D standard deviates) of the multi-class lists M and C.
%
%       If MEMBER is specified then it is used to determine the class
%       probabilities required to accurately determine 2-D decision
%       boundaries.  The default is to use uniform probabilities.
%
%	See also PLOTBOUNDARY, PLOTCLASSES, PLOTELLIPSE

%	(c) Copyright 1995 by Dave Caughey.  All rights reserved.

if nargin < 2 | nargin > 5,
    help plotoutliers
    return;
end;

[K,M] = size(m);
if M ~= 2,
    fprintf( 'plotoutliers: number of dimensions must be two.\n' );
end;

if nargin == 2,			% M,C
    ml = ones(1,K)/K;
    d = 3;
    linestyle = '-';
elseif nargin == 3,
    if isstr( arg1 ),			% M,C,LS
	ml = ones(1,K)/K;
	d = 3;
	linestyle = arg1;
    elseif prod( size( arg1 ) ) == 1,	% M,C,D
	ml = ones(1,K)/K;
	d = arg1;
	linestyle = '-';
    else,				% M,C,MEM
	for i = 1:K,
	    ml(i) = sum(arg1==i)/length(arg1);
	end;
	d = 3;
	linestyle = '-';
    end;
elseif nargin == 4,
    if prod( size( d ) ) == 1,		% M,C,D,LS
	ml = ones(1,K)/K;
	d = arg1;
	linestyle = arg2;
    elseif isstr( arg2 ),		% M,C,MEM,LS
	for i = 1:K,
	    ml(i) = sum(arg1==i)/length(arg1);
	end;
	d = 3;
	linestyle = arg2;
    else				% M,C,MEM,D
	for i = 1:K,
	    ml(i) = sum(arg1==i)/length(arg1);
	end;
	d = arg2;
	linestyle = '-';
    end;
else,					% M,C,MEM,D,LS
    for i = 1:K,
	ml(i) = sum(arg1==i)/length(arg1);
    end;
    d = arg2;
    linestyle = arg3;
end;

hold on;
for i = 1:K,
    [mx,cx] = class_extract(m,c,i);
    [x,y] = plotellipse(mx,(d^2)*cx,500);
    mem = classify( [x;y], m, c, ml ); 
    yy = (mem==i);
    if ~isempty( yy ),
    if ~all(yy),
	x(logical(1-yy)) = NaN*ones(1,sum(1-yy));
   y(logical(1-yy)) = NaN*ones(1,sum(1-yy));
   end
	plot(x,y,linestyle);
    end;
end;
hold off;
