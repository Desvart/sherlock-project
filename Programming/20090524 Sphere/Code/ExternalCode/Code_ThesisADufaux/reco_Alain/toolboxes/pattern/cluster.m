function [m,c,member] = cluster( x,opt1,opt2,opt3,opt4,opt5,opt6,opt7,opt8,opt9,opt10)
%CLUSTER	A non-parametric Gaussian clustering algorithm
%
%Usage:		[M,C] = CLUSTER( X [, <options>] );
%
%	This function tries to cluster the points in X (defined as colums
%	vectors).  It returns the means M and covariances C of the
%	discovered clusters.
%
%	Adding the option 'graphics' will cause nice plots to be displayed.
%	(This is meaningful only for 2-D or 3-D data!)
%
%	Options are:
%		'graphics'			turns on graphics
%		'max'		<int>		expected max # of classes
%		'amax'		<int>		absolute max # of classes
%		'thresh'	<value>		used in class division, def=1
%		'init'		m,c		initial values of mean and cov
%		'member'	<vector>	initial values of mean and cov
%	
%	BUGS: Things get wonky if you have a two-point class -- such a class
%	      has a covariance with a zero determinant, therefore, *every*
%	      point will be closest to this class.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.

x = x';			% this dumb routine uses ROW vectors
M = size(x,2);		% dimensions
K2 = chi2(x');		% chi^2 estimate of normality of entire data set
thresh = 1;
maxK = 0;
amaxK = 10;
K = 1;
N = size(x,1);		% number of samples
m = [];

graphics = 0;

i = 1;
while i < nargin,
    eval( sprintf( 'arg = opt%d;', i ) );
    if ~isstr(arg),
        fprintf( 'cluster: arguments must be property (pairs)\n' );
	return;
    elseif strcmp( arg, 'graphics' ),
	if M > 3 | M < 2,
	    fprintf( 'cluster: graphics turned off (%d dimensions).\n', M );
	else,
	    graphics = 1;
	end;
    elseif strcmp( arg, 'init' ),
	i = i+1;
        eval( sprintf( 'm = opt%d;', i ) );
	i = i+1;
        eval( sprintf( 'c = opt%d;', i ) );
	K = size(m,1);
	fprintf( 'Using initial stats of %d classes by %d dimensions\n', K, M );
    elseif strcmp( arg, 'thresh' ),
	i = i+1;
        eval( sprintf( 'thresh = opt%d;', i ) );
    elseif strcmp( arg, 'member' ),
	i = i+1;
        eval( sprintf( 'member = opt%d;', i ) );
	K = max(member);
	for k = 1:K;
	    y = find(member==k);
	    if length(y) == 0,
		;
	    elseif length(y) == 1,
		m(k,:) = x(y,:);
	    else
		m(k,:) = mean(x(y,:));
	    end;
	    c(k,:) = reshape(cov(x(y,:)),1,M^2);
	end;
	d2 = dbayes( x', m, c );
	m2 = mini([d2;Inf*ones(1,size(d2,2))]);
	for k = 1:K;
	    pwi(k)=sum(m2==k)/N;
	end;
    elseif strcmp( arg, 'amax' ),
	i = i+1;
        eval( sprintf( 'amaxK = opt%d;', i ) );
    elseif strcmp( arg, 'max' ),
	i = i+1;
        eval( sprintf( 'maxK = opt%d;', i ) );
    else
	fprintf( 'cluster: illegal property ''%s''\n', arg );
	return
    end;
    i = i+1;
end;

if maxK == 0,
    maxK = ceil(K2/thresh);	% original estimate of number of classes
    if maxK > 6,
	maxK = 6;
    end;
end;
fprintf( 'Initial estimate of number of classes: %d\n', maxK );

%
% start the iterations by randomly selecting some initial means, and
% assuming that the data is [m,1] distributed
%

if size( m ) == [0 0],
    for k = 1:K,
	m(k,:) = x(k,:);			% arbitrarily select K means
    end;
    for k = 1:K,
	c(k,:) = reshape(eye(M),1,M^2); 	% assume [m,1] distributions
    end;
end;

if graphics,
    clf;
    plotclasses(x',m,c,'simple');
    hold on; plotellipse(m,c,'--'); hold off;
    title( 'Initial Data' );
    drawnow;
end;

n = 1;
oldmember = ones( 1, N );
reallyoldmember = ones( 1, N );

while ( 1 ),

    clear y d xm h xn;

    member = zeros( 1, N );
    i = 0;

    while any( reallyoldmember ~= member ) | i == 0,

	reallyoldmember = member;
	j = 0;

	while any( oldmember ~= member ) | j == 0,

	    %
	    %  Copy current membership list to old membership list
	    %
	    oldmember = member;

	    %
	    %  Calculate the distance from each point to the various means
	    %  Is it a safe assumption that pwi <> 0 for all classes?
	    %
	    m2 = classify( x', m, c );
	    for k = 1:K,
		pwi(k)=sum(m2==k)/N;
	    end;

	    %
	    %  Determine membership for each point, based on minimum distance
       	    %
	    member = classify( x', m, c, pwi );
	    %member = classify( x', m, c );

	    %
	    %  Remove empty/degenerate classes, and reclassify
	    %
	    for k = 1:K,
		ni(k)=sum(member==k);
	    end;
       
       if any(ni<=M),
		fprintf( 'Removing degenerate classes...\n' );
		for k = find(ni<=M),
		    fprintf( '\tclass %d (%d members)\n', k, ni(k) );
		end;
		m = m(ni>M,:);
		c = c(ni>M,:);
		pwi = pwi(ni>M);
		member = classify(x',m,c,pwi(ni>M));
		K = size(m,1);
	    end;

	    %
	    %   Recalculate the means of the new classes
	    %
	    for k = 1:K,		
		y = find(member==k);
		if length(y) == 0,
		    ; % do nothing!
		elseif length(y) == 1,
		    m(k,:) = x(y,:);
		else;
		    m(k,:) = mean(x(y,:));
		end;
	    end;

	    %
	    %  Increment iteration counters and repeat
	    %
	    j = j + 1;
	    n = n + 1;

	end;
	fprintf( '.' );

	%
	% Now that the means are stable, recalculate the covariances
	%

	for k = 1:K,		
	    y = find(member==k);
	    cx = cov(x(y,:));
	    c(k,:) = cx(:)';
	end;

	if graphics,
	    %
	    %  Plot the points and the 1-std dev ellipses
	    %
	    plotclasses(x',m,c,member,'simple');
	    hold on; plotellipse(m,c,'--'); hold off;
	    title( sprintf( 'iteration %d', n ) );
       drawnow;
	end;

        i = i+1;

    end;

    fprintf( '  memberships stabilized\n\n' );

%
%  Now examine the distributions to see if any classes need subdivision
%
%  This is the most heuristic part of the algorithm.  Use the chi-squared
%  test to see if a data set comprises one, or more than one, Gaussian
%  distributions?  Note that hard-limiting has the side effect of making
%  overlapping classes non-Gaussian...
%
%  First, print the scores (based on lengths and chi-squared stats) for 
%  each class.
%

fprintf( 'Class\tMembers\t\t  Chi2\t  Score1\t  Score2\n' );
clear ni X2
    for k = 1:K,
	y = find(member==k);
	ni(k) = length(y);
	X2(k) = chi2( x(y,:)' );
	fprintf( '  %d\t  %d\t\t%6.2f\t%8.1f\t%8.1f\n', ...
	    k, length(y), X2(k), ni(k)*X2(k), ni(k)*(X2(k)-thresh) );
    end;
    fprintf( '\t\t\t\t========\t========\n' );
    fprintf( '\t\t\t\t%8.1f\t%8.1f\n', sum(ni.*X2), sum(ni.*(X2-thresh)) );

%
% Now decide whether we're going to continue with this algorithm
% To do so, all four conditions must be met.
%	1) number of classes must be less than absolute maximum (amaxK)
%	2) a chi-squared stat must exceed the threshold
%	3) a chi-squared stat must exceed *twice* the threshold if the
%	   number of classes exceeds the suggested maximum
%	4) the product of the number of members in a class and the amount the
%	   chi-squared test exceeds the threshold must exceed some entirely
%	   arbitrary hard-coded amount.  Yech!
%  Note that condition 3) amounts to a relaxation of condition 2) when there
%  are a lot of classes.
%
    if ( K < amaxK & max(X2) > thresh & (K < maxK | max(X2) > 2*thresh ) & max(ni.*(X2-thresh))>25)
	y = find(X2>thresh);
	fprintf( 'The following are splittable classes: ' );
	fprintf( '%d ', y );
	
	%
	% select most splittable class, as the that having the highest SCORE1
	%
	sc = y(maxi(X2(y).*ni(y)));
	fprintf( '\nClass %d chosen for subdivision\n  ', sc ); 
	K = K+1;

	[ev ed] = eig(reshape(c(sc,:),M,M));
	j = maxi(diag(ed));

	m(K,:) = m(sc,:)-sqrt(ed(j,j))*ev(:,j)';
	m(sc,:) = m(sc,:)+sqrt(ed(j,j))*ev(:,j)';

	ed(j,j)=ed(j,j)/2;
	%ed(j,j)=ed(j,j)/sqrt(2);
	cx = ev*ed*ev'; cx = (cx+cx')/2;	% make sure it is symmetric
	c(K,:) = cx(:)';
	c(sc,:) = cx(:)';

	if graphics,
	    hold on;
	    if M == 2,
		plotellipse( m(K,:)', cx, 'm--' );
		plotellipse( m(sc,:)', cx, 'm--' );
	    else,
		plotellipse([m(K,:) sc]',[cx 0;0 .25],'m');
		plotellipse([m(sc,:) sc]',[cx 0;0 .25],'m');
	    end;
	    hold off;
       drawnow;
	end;
    else
	fprintf( 'no classes to subdivide because\n' );
	if ( max(X2) <= thresh )
	    fprintf( '\tall classes below threshold.\n' );
	end;
	if ( K == amaxK )
	    fprintf( '\tabsolute max # of classes reached.\n' );
	end;
	if ~( K < maxK | max(X2) > 2*thresh ) 
	    fprintf( '\tsuggested max # of classes exceeded, and all classes below 2*threshold\n' );
	end;
	if (max(ni.*(X2-thresh))<=25)
	    fprintf( '\tmember/excess product reached.\n' );
	end;
	break;
    end;

end;

if graphics,
    plotclasses(x',m,c,member);
    hold on; plotellipse(m,c,'--'); hold off;
    drawnow
end;
