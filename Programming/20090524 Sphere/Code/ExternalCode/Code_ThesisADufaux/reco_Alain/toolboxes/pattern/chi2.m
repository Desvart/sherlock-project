function X2 = chi2( x, arg1, arg2, arg3 )
%CHI2		Calculate the Chi-squared statistics
%
%Usage:		X2 = CHI2( X [,K,DEL] [,'raw'] )
%
%	Chi-squared test as per "Random Data", Bendat and Piersol
%
%	K and DEL have default values of  K=12, delta x = 0.4s (s=1).
%
%	If 'raw' is specified then the data is assumed to be normal
%	with zero mean and unit variance.  Otherwise the data is
% 	forced to this condition.

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.

if nargin == 1,
    K = 12;
    del = .4;
    raw = '';
elseif nargin == 2
    K = 12;
    del = .4;
    raw = arg1;
elseif nargin == 3
    K = arg1;
    del = arg2;
    raw = '';
elseif nargin == 4
    K = arg1;
    del = arg2;
    raw = arg3;
else
    help chi2
end;

[M,N] = size(x);
if strcmp( raw, 'raw' ),
    y = x;
else
    y = normalize( x )';
end;

X2 = 0;
r = ((1:K) - K/2 - 1)*del;
P = diff((erf([-Inf r(2:length(r)) Inf]/sqrt(2))+1)/2)';
F = N*P(:,ones(1,M));
f = hist( y, r + del/2 );
if size(f,1) == 1, f = f'; end;
X2 = sum( f.^2 ./ F ) - N;
X2 = sum(X2)/(M*K);
