function [gamma, logl, framelogl] = mix_post (X, w, mu, Sigma, QUIET);

%mix_post  A posteriori probabilities for a gaussian mixture model.
%	Use: [gamma,logl] = mix_post (X,w,mu,Sigma) returns the a posteriori
%	probabilities. logl is the log-likehood of X.

% Version 1.3
% Olivier Cappé, 1995 - 06/06/97
% ENST Dpt. Signal / CNRS URA 820, Paris

%LB
EPSILON=1e-50;

% Input args.
error(nargchk(4, 5, nargin));
if (nargin < 5)
  QUIET = 0;
end;
[N, p, DIAG_COV] = mix_chk(w, mu, Sigma);
[T, Nc] = size(X);
if (Nc ~= p)
  error('Observation vectors have an incorrect dimension.');
end;

% Compute density values
gamma = gauseval(X, mu, Sigma, QUIET);

% A posteriori probabilities
if (~QUIET)
  fprintf(1, 'Computing a posteriori probabilities...'); time = cputime;
end;
gamma = gamma .* (ones(T,1) * w);
if (nargout > 1)
  %Compute Log-Likelihood - TEST LB if sum(gamma')==0 then sum gamma'=EPSILON - SLOWER BUT SAFER
  framelogl=sum(gamma');
  leng=size(framelogl,2);
  for l=1:leng
     if framelogl(1,l)==0
        framelogl(1,l)=EPSILON;
     end;
  end;
  logl = sum(log(framelogl));
  % Compute log-likelihood
  %logl = sum(log(sum(gamma')));
end;
%LB
gamma = gamma ./ (framelogl' * ones(1,N));
%gamma = gamma ./ ((sum(gamma'))' * ones(1,N));
if (~QUIET)
  time = cputime - time; fprintf(1, ' (%.2f s)\n',time);
end;
