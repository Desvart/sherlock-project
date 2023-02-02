function [xx,yy,zz] = plotellipse( m, c ,linestyle, np )
%PLOTELLIPSE		Draw ellipse(s)/ellipsoid(s) described by means and covariances
%
%Usage:		H = PLOTELLIPSE( M, C [, LINESTYLE] [,T] )
%		[X Y] = PLOTELLIPSE( M, C [, LINESTYLE] [,T] )
%		[X Y Z] = PLOTELLIPSE( M, C [, LINESTYLE] [,T] )
%
%	This function draws a 2-D ellipse or 3-D ellipsoid centred at M
%	with covariance C, using an optional LINESTYLE.
%
%	M and C can describe either a single ellipse/ellipsoid or designate
%	multi-class lists, in which case LINESTYLE applies to all drawn
%	ellipses/ellipsoids.
%
%	If a single output argument is specified then the handles for each
%	line element drawn are returned in H.  Otherwise the X, Y (and
%	possibly, Z) coordinates of the last ellipse/ellipsoid are returned.
%
%	See also PLOTCLASSES

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.

if nargin < 2 | nargin > 4,
    help plotellipse
    return
elseif nargin == 2,
    linestyle = '-';
    np = 0;
elseif nargin == 3,
    if ~isstr( linestyle ),
	np = linestyle;
	linestyle = '-';
    else
	np = 0;
    end;
end;

[m,c] = class_multi( m, c );
[K,M] = size(m);
if M < 2 | M > 3
    fprintf( 'plotellipse: data must be 2-D or 3-D only.\n' );
    return;
end;

if np == 0,
    if M == 2,
	np = 100;
    else
	np = 12;
    end;
end;

hold_status = get( gca, 'NextPlot' );
h = [];
for i = 1:K,
    [mx,cx] = class_extract( m, c, i );
    if M == 2,
	[v d] = eig(cx);
	t = linspace( 0, 2*pi, np );
	z = v*sqrt(d)*[cos(t);sin(t)] + mx*ones(size(t));
	x = z(1,:);
	y = z(2,:);
	    
	if nargout ~= 2,
	    h = [h plot( x, y, linestyle )]; hold on;
	end;
    elseif M == 3,
	[sx,sy,sz] = sphere(np);
	[cv,cd] = eig(cx);

	clear vx vy vz
	for j = 1:(np+1),
	    vv = cv*sqrt(cd)*[sx(j,:);sy(j,:);sz(j,:)];
	    vx(j,:) = vv(1,:)+mx(1);
	    vy(j,:) = vv(2,:)+mx(2);
	    vz(j,:) = vv(3,:)+mx(3);
	end;

	if nargout ~= 3,
	    hyperline_h1 = plot3( vx,vy,vz,    linestyle ); hold on;
	    hyperline_h2 = plot3( vx',vy',vz', linestyle );
	    h = [h hyperline_h1' hyperline_h2'];
	end;
    end;
end;

set( gca, 'NextPlot', hold_status );

if nargout == 1,
    xx = h;
elseif M == 2 & nargout == 2
    xx = x;
    yy = y;
elseif M == 3 & nargout == 3
    xx = vx;
    yy = vy;
    zz = vz;
elseif nargout > 0
    fprintf( 'plotellipse: illegal number of output arguments\n' );
end;
