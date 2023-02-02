% ******************************************************************
% File to Test the Recognition System
% ******************************************************************

function [membership, maxlogl, cert] = testing( m, C, w, testfiles, ...
    Test_Sig_Nbr, v_PCA, d_PCA, v_LDA, d_LDA, PCA_dim, LDA_dim, totmean, totstd, SNR)


% ------------------------------------------------------------------
% Initialization 
% ------------------------------------------------------------------

% Total number of sound samples for training
Sound_Nbr = size(testfiles, 1);

% Number of sound classes
Class_Nbr = length(Test_Sig_Nbr);

% Initialize features Matrix
feat = [];


% ------------------------------------------------------------------
% Features Extraction  
% ------------------------------------------------------------------

% Take each successive sound in variable x, and extract its features
for i = 1:Sound_Nbr,
    
   % Read sound samples (x) and sampling frequency (fs) from file 
   [x, fs] = wavread(testfiles(i,:),'native');
   x = double(x); % Convert samples to double type
  
   % Add White Gaussian Random noise to the sound, to reach specified SNR
   % Note : For white Gaussian noise, the level corresponds to the variance
   %        if n gaussian white noise => var(n) = sum(n.^2)/length(n)
   soundlevel = 10*log10(sum(x.^2)/length(x)); % Sound level (in average)
   noiselevel = soundlevel - SNR; % Noise level
   % noisevar = 10.^(noiselevel/10); % Variance of the noise (Gauss. white)
   noisesigma = 10.^(noiselevel/20); % Standard deviation of the noise
   n = noisesigma * randn(size(x)); % Noise generation for specified SNR
   x = x + n; % Add noise
   
   % Perform features extraction for current sound (column vector returned)
   tempfeat = features(x, fs);
   
   % Aggregate the new features to the features matrix
   feat = [feat tempfeat];
   
   % Determine how many frames are contained in each sound file
   Frame_Nbr(i) = size(tempfeat,2);

end;


% ------------------------------------------------------------------
% Features Normalisation 
% ------------------------------------------------------------------

% Calculate features Mean in each dimension 
totmean = mean(feat, 2); 
% Subtract mean
normfeat = feat - repmat(totmean, 1, size(feat, 2));
% Calculate features standard deviation in each dimension
totstd = std(normfeat, 0, 2);  
% Normalize by the standard deviation
normfeat = normfeat ./ repmat(totstd, 1, size(normfeat, 2));
feat = normfeat; % Note: Comment to bypass features normalization


% ------------------------------------------------------------------
% Features Dimension Reduction  
% ------------------------------------------------------------------

% PCA Reduction
%redfeat = reduce(feat, v_PCA, d_PCA, PCA_dim); % Reduce dimension
%redfeat = redfeat - repmat(mean(redfeat,2), 1, Sound_Nbr); 

% LDA Reduction
%redfeat = reduce(redfeat, v_LDA, d_LDA, LDA_dim, 0); % Reduce dimension
%feat = redfeat; % Note: Comment to bypass features reduction


% ------------------------------------------------------------------
% GMM Classification
% ------------------------------------------------------------------

% Define constants
QUIET = 1; % No log

% Loop for every sound
for j = 1:Sound_Nbr,
   start = sum(Frame_Nbr(1:j-1))+1;
   stop = sum(Frame_Nbr(1:j));
   
   % Determination of A posteriori probabilities 
   % and log likelihood for each class and each frame
   for i = 1:Class_Nbr,
      [gamma loglikelihood(j,i), framecert(i,start:stop)] = mix_post(feat(:,start:stop)', w(i,:), m(:,:,i), C(:,:,i), QUIET);
   end;
   
   % Determine certainties
   framecert(:,start:stop) = framecert(:,start:stop)./repmat(sum(framecert(:,start:stop)),Class_Nbr,1);
   cert(:,j) = mean((framecert(:,start:stop))')';

   % Determine Class Membership
   membership(j) = find(loglikelihood(j,:) == max(loglikelihood(j,:)));
   maxlogl(j) = loglikelihood(j,membership(j));
end;
