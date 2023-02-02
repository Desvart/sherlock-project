% This file provides a more elaborate example of the use of the h2m
% functions for a 1-D signal:
%
% impnois.mat contains a low level signal contaminated by impulsive noise.
% This actually comes from a real audio signal contaminated by impulsive
% noise. X contains the residual of a standard LPC analysis, which makes it
% look very much like a white noise contaminated by impulsive spikes. The
% HMM provides an interesting way of automatically detecting the corrupted
% parts of the signal.
%
% Beware : This is not a real demo, so you should edit the source file
% before executing it if you wan't to understand what's going on!

% Olivier Cappé, 24/03/97
% ENST Dpt. Signal / CNRS URA 820, Paris

load impnois;

% First, this signal is modeled as a two-state mixture of Gaussian centered
% variables with different variances.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization values (class 1 is supposed to represent the background signal
% parts and class 2 corresponds to the impulsive noise)
mu =  [0 ; 0];
Sigma = [10; 100000];
w = [0.9 0.1]
w_ = w;
Sigma_ = Sigma;

% EM iterations (note that the use of the low-level functions makes it
% possible to force the value of means mu to [0 0]). There is however a
% little trick there and in principle mix_par should be modified to
% handle this case properly (because Sigma_ is estimated using mu_) but
% the difference is not significant on this data.
COV_TYPE = 1;
n_it = 10;
for i = 1:n_it
  gamma = mix_post(X, w_, mu, Sigma_);
  [mu_, Sigma_, w_] = mix_par(X, gamma, COV_TYPE);
end;

% Estimated values denote two classes with very different variances and
% statistical frequencies
w_
Sigma_

% Let's plot the signal (top) with the a posteriori probability of being
% in the second class, which represents the impulsive noises (bottom)
clf;
subplot(2,1,1);
plot(X);
subplot(2,1,2);
plot(gamma(:,2));

% The two classes appear to be meaningful, however the model fails to
% represent the "duration" of the impulsive noise
pause;



% If we model the same data with an HMM, the data will no more be considered
% as i.i.d...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial values
pi0 = [1 0];
A = [0.95 0.05; 0.5 0.5];
A_ = A;
Sigma_ = Sigma;

% EM iterations
for i = 1:n_it
  [alpha, beta, logscale, dens] = hmm_fb(X, A_, pi0, mu, Sigma_);
  [A_, pi0_] = hmm_tran(alpha, beta, dens, A_, pi0);
  [mu_, Sigma_] = hmm_dens(X, alpha, beta, COV_TYPE);
end;

% Estimated values (note the differences in the transition probabilities from
% the two states)
A_
Sigma_

% Let's compute the most likely state sequence
[logl,path] = hmm_vit(X, A_, pi0, mu, Sigma_);

% And plot the data (top) with the a posteriori probability of being
% in the second class, which represents the impulsive noises (bottom,
% yellow curve) as well as the most likely state sequence (bottom, red curve)
clf;
subplot(2,1,1);
plot(X);
subplot(2,1,2);
plot(gamma(:,2));
hold on;
plot(path-1, 'r');	% O stands for the first class and 1 for the second

% Note how the most likely state sequence provides an efficient segmentation
% of the signal, while this would not be the case for a decision based on the
% a posteriori most likely individual states.
