function H = entropy( x, m, c, delta )
%ENTROPY		Calculate entropy of a process (assumed Gaussian)
%
%Usage:		H = ENTROPY( X, M, C, DELTA )
%
%	This function calculates the entropy of X supposing that
%	it came from a theoretical Gaussian distribution having
%	a p.d.f. described by mean M and covariance C.
%	
%	Note that entropy uses probabilities, not probabibility
%	densities.  Unfortunately, all we know is the p.d.f.
%	Therefore, this routine uses the mapping
%		H(x) = A*(Hpdf(x) - log2(A)*sum(pdf(x)));
%	where
%		Hpdf(x) = -sum(pdf(x).*log2(pdf(x)));
%
%	The scaling factor A is used 'discretize' the continuous p.d.f.
%	as required for the entropy calculation.  The parameter DELTA
%	is used to determine the sampling of the p.d.f. (actually, the
%	integration range).  As DELTA approaches zero, so will the
%	calculated probabilities, and hence, so will the entropy.

A = sqrt(2*pi)*sqrt(det(c))*erf((delta/2)/sqrt(2*det(c)));
p = pdf( x, m, c );
Hpdf = -sum(p.*log2(p));
H = A*(Hpdf - log2(A)*sum(p));
