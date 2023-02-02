function [A_, pi0_] = hmm_tran (alpha, beta, dens, A, pi0, QUIET);

%hmm_tran  Reestimation the transition part of an HMM.
%	Use : [A_,pi0_] = hmm_tran(alpha,beta,dens,A,pi0). If A and
%	piO are sparse, the output estimates are also sparse (and
%	only the relevant values are reestimated).

% Version 1.3
% Olivier Cappé, 12/03/96 - 17/03/97
% ENST Dpt. Signal / CNRS URA 820, Paris

% Dimensions (without checking A and pi0)
error(nargchk(5, 6, nargin));
if (nargin < 6)
  QUIET = 0;
end;
if ((size(alpha) ~= size(beta)) | (size(alpha) ~= size(dens)))
  error('First three matrices should have the same size.');
end;
[T, N] = size(alpha);

% Initial probabilities
if (~QUIET)
  fprintf(1, 'Reestimating transition parameters...'); time = cputime;
end;
if (issparse(pi0))
  ind = find(pi0);
  pi0_ = sparse(zeros(1,N));
  pi0_(ind) = alpha(1,ind) .* beta(1,ind) / sum(alpha(1,ind) .* beta(1,ind));
else
  pi0_ = alpha(1,:) .* beta(1,:) / sum(alpha(1,:) .* beta(1,:));
end;

% Transition matrix
if (issparse(A))
  A_ = sparse(zeros(size(A)));
  for i=1:N
    ind = find(A(i,:));
    num = (alpha(1:(T-1),i) * ones(1,length(ind))) .* dens(2:T,ind) .* beta(2:T,ind);
    A_(i,ind) = A(i,ind) .* sum(num);
    A_(i,ind) = A_(i,ind) / sum(A_(i,ind));
  end;
else
  A_ = zeros(size(A));
  for i=1:N
    % Compute unnormalized transition probabilities
    num = (alpha(1:(T-1),i) * ones(1,N)) .* dens(2:T,:) .* beta(2:T,:);
    A_(i,:) = A(i,:) .* sum(num);
    % Normalization
    A_(i,:) = A_(i,:) / sum(A_(i,:));
  end;
end;
if (~QUIET)
  time = cputime - time; fprintf(1, ' (%.2f s)\n', time);
end;
