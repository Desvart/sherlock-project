function [cg,xg]=fillclassify( m, c, nx )
%FILLCLASSES	Grid and colour the current figure according to classification
%
%Usage:		FILLCLASSIFY( M, C [,N] )
%		[CG,XG]=FILLCLASSIFY( M, C [,N] )
%
%	This routine grids the current figure such that the x-axis is
%	divided in to N pieces, and classifies the whole image space.
%
%	If no output arguments are specified, then the results are
%	plotted using IMAGE and a colourmap of size K+2.
%
%	Unfortunately, the axes limits must already be defined.

if nargin == 2,
    nx = 80;
elseif nargin ~= 3,
    help fillclassify;
    return;
end;

pl = get(gca,'position').*get(gcf,'position');
ny = ceil(nx*pl(4)/pl(3));
rl = get(gca,'renderlimits');
xl = linspace(rl(1),rl(2),nx);
yl = linspace(rl(3),rl(4),ny);
[a b] = meshgrid(xl,yl);
Xg = [a(:) b(:)]';
mg = reshape(classify(Xg,m,c),ny,nx);
if nargout == 0,
    image(xl,yl,mg+1);axis xy; colormap(gray(size(m,1)+2));
    %dg = min(mahalanobis(Xg,m,c));
    %cd(dg>=9) = NaN*ones(1,sum(d>=9));
else
    cg = mg;
    xg = Xg;
end
