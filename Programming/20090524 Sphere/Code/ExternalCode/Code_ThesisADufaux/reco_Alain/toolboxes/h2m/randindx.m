function I = randindx(p, T, NO_CHK);

%randindx  Generates random indexes with a specified probability distribution.
%	I=randindx(p,T) returns and array of T indexes distributed as specified
%	by p (which should be a normalized probability vector). By default,
%	T=1.

% Version 1.3
% Olivier Capp?, 1995 - 11/07/97
% ENST Dpt. Signal / CNRS URA 820, Paris

% Max deviation from 1
MAX_DEV = 1e-7;
% Minimum probability
MIN_PROB = 1e-10;

% Default arguments
if (nargin < 3)
  NO_CHK = 0;
end;
if (nargin < 2)
  T = 1;
end;

% Check that p is indeed a probability vector (can be skipped)
if (~NO_CHK)
  % Check probabilities
  p = p(1:length(p));
  if (any(p < 0) | any(p > 1))
    error('inconsistent probability');
  end;
  if (abs(sum(p)-1) > MAX_DEV)
    error('probabilities are not normalized');
  end;
end;

% Construct a vector which contains the inverse CDF limits
% Taking care of the case where there are null probabilities (the inv.
% cdf table should not contain identical values)
if (any(p < MIN_PROB))
  ind = find(p);
  p = p(ind);
  NULL_FLAG = 1;
else
  NULL_FLAG = 0;
end;
p_p = cumsum(p);
p_m = [0 p_p(1:(length(p_p)-1))];

% Generates random numbers
R = rand(1, T);
I = zeros(1, T);
if (T > 1)
  for i = 1:T
    I(i) = find((R(i) >= p_m) & (R(i) < p_p)); 
  end;
else
  % Try to do something slightly more efficient here
  I = 1;
  while (R >= p_p(I))
    I = I+1;
  end;
end;
if (NULL_FLAG)
  % Revert to the true indexes in case of null probabilities
  I = ind(I);
end;
