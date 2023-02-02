function z = bound2( m1, c1, m2, c2, pw1, pw2, T )
%BOUNDARY	Calculate the decision boundary between 2-D gaussian classes
%
%Usage:         XP = BOUNDARY( M1, C1, M2, C2, PW1, PW2, T  )
%
%       This function calculates the decision boundary between *two*
%       Gaussian distributions described by their means M1,M2 and
%       covariances C1,C2.  The curves are calculated at T points.
%
%       This is NOT intended to be a user-callable routine.  It is
%       used exclusively by PLOTBOUNDARY

%       (c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.

ic1 = inv(c1);
ic2 = inv(c2);

A = ic1-ic2;
b = m1'*ic1 - m2'*ic2;
c = (2*log(pw2)-2*log(pw1)-log(det(c2))+log(det(c1))) + m1'*ic1*m1 - m2'*ic2*m2;

[v,d2] = eig(A); d2 = diag(d2);
g = b*v;

d2z = abs(d2)<eps;
if sum(d2z)==2,			% do straight line
    if any(g),
	%disp('straight line');
	t = 10*linspace(-1,1,T);
	mm = (m1+m2)/2;
	mv = (m2-m1);
	y = mm*ones(1,T)+[mv(2)*t;-mv(1)*t];
    else
	fprintf( 'boundary: coincident densities\n' );
	y = [];
    end;
elseif sum(d2z) == 1 & g(2) ~= 0,	% do parabola
    %disp( 'parabola' );
    t = 20*linspace(-1,1,T);
    y = [t;(d2(1)*(t-g(1)/d2(1)).^2-(g(1)^2/d2(1)-c))/(2*g(2))];
elseif sum(d2z) == 1 & g(2) == 0,	% do inf ellipse/hyperbola (2 straight lines)
    t = 20*linspace(-1,1,T);
    e = sqrt(g(1)^2/d2(1) - c)
    z = e./[sqrt(d2(1)) -sqrt(d2(1))]+g(1)/d2(1);
    y = [z(1)*ones(1,T) NaN z(2)*ones(1,T);t NaN t];
elseif sign(prod(d2)) > 0, 	% do ellipse
    esqr = (g(1)^2/d2(1)+g(2)^2/d2(2) - c);
    e = sqrt(abs(esqr));
    t = linspace(-pi,pi,T);
    beta = [cos(t);sin(t)];
    gamma = [e*beta(1,:)/sqrt(d2(1));e*beta(2,:)/sqrt(d2(2))];
    y = [gamma(1,:)+g(1)/d2(1);gamma(2,:)+g(2)/d2(2)];
else				% do hyperbola
    esqr = (g(1)^2)/d2(1)+(g(2)^2)/d2(2) - c;
    e = sqrt(abs(esqr));
    t = linspace(-1,1,T); t = (t.^2).*sign(t);
    %tmax = max(acosh(10*sqrt(abs(d2)/(e+0.000001))))
    tmax = max(asinh(10*sqrt(abs(d2))/(e+0.000001)));
    t = t*tmax;
    beta = [cosh(t);sinh(t)]; beta = [beta [NaN;NaN] -beta [NaN;NaN]];
    if xor(esqr<0,d2(1)<0),
	beta = flipud(beta);
    end;
    gamma = e*[beta(1,:)/sqrt(abs(d2(1)));beta(2,:)/sqrt(abs(d2(2)))];
    y = [gamma(1,:)+g(1)/d2(1);gamma(2,:)+g(2)/d2(2)];
end;
z = v*y;
if ~isreal(z), fprintf( 'boundary: complex data\n' ); end;
