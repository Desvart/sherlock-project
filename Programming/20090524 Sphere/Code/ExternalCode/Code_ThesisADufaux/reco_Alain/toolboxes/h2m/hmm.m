function [A_, pi0_, mu_, Sigma_, logl] = hmm (X, A, pi0, mu, Sigma, n_it);

%hmm       Performs multiple iterations of the EM algorithm.
%	   This is just a call to the lower-level functions.
%          Use: [A_,pi0_,mu_,Sigma_,logl] = hmm(X,A,pi0,mu,Sigma,n_it)

% Version 1.3
% Olivier Cappé, 07/02/97 - 04/03/97
% ENST Dpt. Signal / CNRS URA 820, Paris

% Turn verbose mode off
QUIET = 1;
% Check input data and dimensions
error(nargchk(6, 6, nargin));
% Check that the initialization value are correct
[N, p, DIAG_COV] = hmm_chk(A, pi0, mu, Sigma);
% Check size of training data
[T,v] = size(X);
if (v ~= p)
  error('Size of training dat is incorrect.');
end; 
% Use supplied values as initialization
A_ = A;
pi0_ = pi0;
mu_ = mu;
Sigma_ = Sigma;

logl = zeros(1,n_it);
for i = 1:n_it
  [alpha, beta, logscale, dens] = hmm_fb(X, A_, pi0_, mu_, Sigma_, QUIET);
  logl(i) = log(sum(alpha(T,:))) + logscale;
  [A_, pi0_] = hmm_tran(alpha, beta, dens, A_, pi0_, QUIET);
  [mu_, Sigma_] = hmm_dens(X, alpha, beta, DIAG_COV, QUIET);
  fprintf(1, 'Iteration %d:\t%.3f\n', i, logl(i));
end;
