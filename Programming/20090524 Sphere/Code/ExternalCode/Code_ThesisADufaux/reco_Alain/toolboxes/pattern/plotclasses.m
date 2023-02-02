function hout = plotclasses( x, m, c, arg1, arg2, arg3, arg4, arg5 )
%PLOTCLASSES	Pretty plot of multi-class data
%
%Usage:		H = PLOTCLASSES( X [,ARGS] );
%
%	This function generates pretty plots of the data X in either 2-D
%	or 3-D feature space.
%
%	The arguments that can be passed to the function are as follows:
%
%		    M,C		means and covariances
%		    MEMBER	membership of M,C
%		    MEMBER2	membership used to calculate class probabilities
%		    LS1,LS2	linestyles as used by PLOTBOUNDARY
%		    'simple'	inhibits boundary plotting
%
%	Note optional arguments must be specified in the order above
%	(i.e., M and C must be before MEMBER).  Both or neither M and C 
%	must be specified.  Both or neither LS1 and LS2 must be specified
%	(although LS2 may be a null string).
%	
%	If M and C are omitted all data is assumed to belong to a single
%	class, unless MEMBER is specified.
%
%	If MEMBER is omitted, Bayesian classification is performed.
%
%	If MEMBER2 is specified then it is used to determine the class
%	probabilities required to accurately determine 2-D decision
%	boundaries.  The default is to use uniform probabilities.
%
%	If X is 2-D, then the decision boundaries are plotted along with
%	the data, unless 'simple' is specified.
%
%	If X is 3-D, then the 1-std ellipsoids are also plotted, unless
%	'simple' is specified.
%
%	See also PLOTELLIPSE, PLOTBOUNDARY

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.

member = [];
member2 = [];
ls1 = '-';
ls2 = '';
simple = '';

if nargin == 1,			% X
    m = mean(x');
    c = reshape(cov(x'),1,size(m,2)^2);
    simple = 'simple';
elseif nargin == 2,
    if isstr( m ),		% X,SIMPLE
	simple = m;
	m = mean(x');
	c = reshape(cov(x'),1,size(m,2)^2);
    else			% X,MEMBER
	member = m;
	[m,c] = estimate(x,member);
    end;
elseif nargin == 3,
    if isstr( m ),		% X,LS1,LS1
	ls1 = m;
	ls2 = c;
	m = mean(x');
	c = reshape(cov(x'),1,size(m,2)^2);
    elseif isstr( c ),		% X,MEMBER,SIMPLE
	simple = c;
	member = m;
	[m,c] = estimate(x,member);
    else			% X,M,C
        ;
    end;
elseif nargin == 4,		
    if isstr( c ),		% X,MEMBER,LS1,LS2
	ls2 = arg1;
	ls1 = c;
	member = m;
	[m,c] = estimate(x,member);
    elseif isstr(arg1),		% X,M,C,SIMPLE
	simple = arg1;
    else			% X,M,C,MEMBER
	member = arg1;
    end; 
end;

%
%  By now, m and c will definitely have been set
%
[K,M] = size(m);
if isempty( member ),
    member = classify(x,m,c);
end;

if nargin == 1,			% X
   m = []; c = [];
elseif nargin == 3,			% X,M,C
    ;
elseif nargin == 4,			% X,M,C,SIMPLE
    ;
elseif nargin == 5,
    if isstr(arg1),		% X,M,C,LS1,LS2
	ls1 = arg1;
	ls2 = arg2;
    elseif isstr(arg2),		% X,M,C,MEMBER,SIMPLE
	member = arg1;
	simple = arg2;
    else			% X,M,C,MEMBER,MEMBER2
	member = arg1;
	member2 = arg2;
    end;
elseif nargin == 6,
    if isstr(arg2),		% X,M,C,MEMBER,MEMBER2,SIMPLE
	member = arg1;
	ls1 = arg2;
	ls2 = arg3;
    else,			% X,M,C,MEMBER,LS1,LS2
	member = arg1;
	member2 = arg2;
	simple = arg3;
    end;
elseif nargin == 7,
    if isstr(arg2),		% X,M,C,MEMBER,LS1,LS2,SIMPLE
	member = arg1;
	ls1 = arg2;
	ls2 = arg3;
	simple = arg4;
    else,			% X,M,C,MEMBER,MEMBER2,LS1,LS2
	member = arg1;
	member2 = arg2;
	ls1 = arg3;
	ls2 = arg4;
    end;
elseif nargin == 8,		% X,M,C,MEMBER,MEMBER2,LS1,LS2,SIMPLE
    member = arg1;
    member2 = arg2;
    ls1 = arg3;
    ls2 = arg4;
    simple = arg5;
else
    help plotclasses
    return
end;

if length(member) ~= size(x,2),
    fprintf( 'plotclasses: X and MEMBER must be the same length\n' );
    return;
end;

gco = get(gca,'colororder');
h = [];
if M == 2,
    for i = 1:max(member),
	y = find(member==i);
	if ~isempty(y),
	    hr=plot(x(1,y),x(2,y),'.' ); hold on;
	    h = [h hr];
	    set(hr,'color',gco(rem(i-1,size(gco,1))+1,:),'markersize',8);
	end;
    end; hold off;
    if strcmp( simple, 'simple' ) == 0,
	hold on; axis equal; drawnow;
	xt = get(gca,'xtick'); yt = get(gca,'ytick');
   ax = [min(xt) max(xt) min(yt) max(yt)];
   axis( ax );
	if isempty(member2),
	    ml = ones(1,K)/K;
	else
	    for i=1:max(member2), ml(i)=sum(member2==i); end;
	    ml=ml/length(member2);
	end;
	plotboundary(m,c,ml,1200,ls1,ls2); axis( ax );
	%plotboundary(m,c,ml,50,ls1,ls2); axis('equal');
    end;
elseif M == 3,
    for i = 1:max(member),
	y = find(member==i);
	if ~isempty(y),
	    hd(i)=plot3(x(1,y),x(2,y),x(3,y),'.'); hold on;
	    set(hd(i),'markersize',8,'color',gco(rem(i-1,size(gco,1))+1,:));
	end;
	if strcmp( simple, 'simple' ) == 0,
	    hold on;
	    [mx,cx] = class_extract(m,c,i);
	    h=plotellipse(mx,cx);
	    for hi=h, set(hi,'color',gco(rem(i-1,size(gco,1))+1,:)); end;
	end;
    end;
    grid on;
else
    fprintf( 'plotclasses: must be 2-D or 3-D data.\n' );
    return;
end;
xlabel( 'Feature #1' ); ylabel( 'Feature #2' ); hold off
if M == 3, zlabel( 'Feature #3' ); end;
if nargout == 1,
    hout = h;
elseif nargout > 0,
    fprintf( 'plotclasses: illegal number of output arguments\n' );
end;
