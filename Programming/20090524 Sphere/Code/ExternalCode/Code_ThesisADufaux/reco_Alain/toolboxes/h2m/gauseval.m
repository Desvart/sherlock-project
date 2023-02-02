function dens = gauseval(X, mu, Sigma, QUIET);

%gauseval  Computes a set of multivariate normal density values.
%	   In the case of diagonal covariance matrices, the mex-file c_dgaus
%	   will be used if it found on matlab's search path.
%	Use : dens = gauseval(X, mu, Sigma) where
%	X (T,p)		T observed vectors of dimension p
%	mu (N,p)	N mean vectors
%	Sigma (N,p)	diagonals of the covariance matrices
%   or	Sigma (N,p*p)	Full covariance matrices
%	dens (T,N)	Probability density for vector and each Gaussian dist.

% Version 1.3
% Olivier Cappé, 12/03/96 - 16/07/97
% ENST Dpt. Signal / CNRS URA 820, Paris

SEUIL=0.001;%seuil absolu sur les valeurs minimales des variances

% Input arguments
error(nargchk(3, 4, nargin));
if (nargin < 4)
  QUIET = 0;
end;
% Dimension of the observations
[T, p] = size(X);
% Check means of Gaussian densities
[N, Nc] = size(mu);
if (Nc ~= p)
  error('Dimension of mean vectors is incorrect.');
end;
% Check covariance matrices
[Nr, Nc] = size(Sigma);
if (Nc ~= p)
  error('The size of the covariance matrices is incorrect.');
end;
if (Nr == N)
  DIAG_COV = 1;         % Also true if the dimension is 1
elseif (Nr == p*N)
  DIAG_COV = 0;
else
  error('The size of the covariance matrices is incorrect.');
end;

% Compute density values
if (~QUIET)
  fprintf(1, 'Computing density values...'); time = cputime;
end;
if (DIAG_COV)
  if (exist('c_dgaus') == 3)
    % Use the mex-file version to speed up the computation
    dens = c_dgaus(X, mu, Sigma);    
  else
    if (p > 1)
      nm = prod(Sigma');
    else
      % Beware of prod when the dimension of the vector is 1 (!)
      nm = Sigma';
    end;
    if (any(nm < realmin))
       %modif LB evite l arret du process
       error('Determinant is negative or zero.');
       %nm = 1 ./ sqrt((2*pi)^p * abs(nm));
    else
      %nm = 1 ./ sqrt((2*pi)^p * nm);
      % Replace by the following line if you are using the MATLAB compiler
      nm = 1 ./ realsqrt((2*pi)^p * nm);
    end
    dens = zeros(T, N);
    for i=1:T
      for j=1:N
        dens(i,j) = sum((X(i,:)-mu(j,:)) .^2 ./ Sigma(j,:));
      end;
      dens(i,:) = nm .* exp(-0.5 * dens(i,:));
    end;
  end;
else %full covariance
  Pr = zeros(size(Sigma));
  nm = zeros(1, N);
  dens = zeros(T, N);
  % Compute precision matrices and normalization constant once
  for i=1:N
    Pr((1+(i-1)*p):(i*p),:) = inv(Sigma((1+(i-1)*p):(i*p),:));
    nm(i) = det(Sigma((1+(i-1)*p):(i*p),:));
    %Ajout LB - case det<0
    %if(nm(i) < realmin)
    %   Sigma((1+(i-1)*p):(i*p),:)=Sigma((1+(i-1)*p):(i*p),:)+SEUIL;
    %   Pr((1+(i-1)*p):(i*p),:) = inv(Sigma((1+(i-1)*p):(i*p),:));
	 %   nm(i) = det(Sigma((1+(i-1)*p):(i*p),:));
    %end
    %fin ajout LB
  end;
  if (any(nm < realmin))
     %error('Determinant is negative or zero.');
     nm = 1 ./ realsqrt((2*pi)^p * abs(nm));
  else  
     %nm = 1 ./ sqrt((2*pi)^p * nm);
     %Replace by the following line if you are using the MATLAB compiler
     nm = 1 ./ realsqrt((2*pi)^p * nm);

  end
  % Compute values for all densities and all observations
  for i=1:T
    for j=1:N
      dens(i,j) = (X(i,:)-mu(j,:)) * Pr((1+(j-1)*p):(j*p),:) * (X(i,:)-mu(j,:))';
    end;
    dens(i,:) = nm .* exp(-0.5 * dens(i,:));
  end;
end;
if (~QUIET)
  time = cputime - time; fprintf(1, ' (%.2f s)\n', time);
end;
