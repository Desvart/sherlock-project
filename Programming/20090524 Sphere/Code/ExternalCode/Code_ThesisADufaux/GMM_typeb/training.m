% ******************************************************************
% File to Perform the Training of the Recognition System
% ******************************************************************

function [m, C, w, v_PCA, d_PCA, v_LDA, d_LDA, totmean, totstd] = ...
    training(trainfiles, Train_Sig_Nbr, Gaussian_Nbr, PCA_dim, LDA_dim, SNR)


% ------------------------------------------------------------------
% Initialization 
% ------------------------------------------------------------------

% Total number of sound samples for training
Sound_Nbr = size(trainfiles,1);

% Number of sound classes
Class_Nbr = length(Train_Sig_Nbr);

% Initialize features Matrix
feat = [];

% Allocate space for variable holding the number of frames in each sound
Frame_Nbr = zeros(1,Sound_Nbr);


% ------------------------------------------------------------------
% Features Extraction  
% ------------------------------------------------------------------

% Take each successive sound in variable x, and extract its features
for i = 1:Sound_Nbr,
    
   % Read sound samples (x) and sampling frequency (fs) from file 
   [x, fs] = wavread(trainfiles(i,:),'native');
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

% Determine Target Class for each sound frame
target = [];
for j = 1:Class_Nbr, 
    start = sum(Train_Sig_Nbr(1:j-1))+1; 
    stop = sum(Train_Sig_Nbr(1:j)); 
    target = [target j*ones(1, sum(Frame_Nbr(start:stop)))]; 
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

% % PCA Reduction
% % Calculate eigen vectors and diagonal matrix
% [v_PCA, d_PCA] = coveig(feat); 
% % Reduce dimension
% redfeat = reduce(feat, v_PCA, d_PCA, PCA_dim); % => unit variance
% %redfeat = redfeat - repmat(mean(redfeat,2), 1, Sound_Nbr); % => zero-mean
% 
% % LDA Reduction
% % Calculate eigen vectors and diagonal matrix
% [v_LDA, d_LDA] = separability(redfeat, target, Class_Nbr);
% % Reduce dimension
% redfeat = reduce(redfeat, v_LDA, d_LDA, LDA_dim, 0);
% feat = redfeat; % Note: Comment to bypass features reduction

% Bypass reduction
v_PCA = []; d_PCA = [];
v_LDA = []; d_LDA = [];


% ------------------------------------------------------------------
% Build Sound Models according to Expectation Maximization algorithm
% ------------------------------------------------------------------

% Number of iterations for the EM algorithm
n_it_EM = 20;

% Number of iterations for the SVQ algorithm
n_it_SVQ = 100;

% Define constants
DIAG_COV = 0; % 
QUIET = 1; % No log

% Loop for each class
for i = 1:Class_Nbr,
   
   % Initialize EM algorithms
   % -------------------------
   
   % Locate the features extracted from sounds in current class 
   featbyclass = feat(:, find(target == i))';
      
   % Use unsupervised SVQ algorithm to determine initial values 
   % for the gaussians mean. Associated labels are provided as well 
   [Gaussian_mu, label] = svq(featbyclass, Gaussian_Nbr, n_it_SVQ);
   
   % Alternative: Use random initialization of Gaussian means
   % Gaussian_mu = randn(Gaussian_Nbr, size(feat,1)); 
   
   % Initialize covariance matrices for every gaussian
   Gaussian_Sigma = [];
   for j = 1:Gaussian_Nbr,
       Gaussian_Sigma = [Gaussian_Sigma; cov(featbyclass((label==j),:))];
   end;

   % Set equal initial values for the Gaussian weights
   Gaussian_w = ones(1, Gaussian_Nbr) / Gaussian_Nbr;
   
   % EM algorithms loops
   % -------------------------
   
   for j = 1:n_it_EM
        [gamma, logl(j)] = mix_post(featbyclass, Gaussian_w, Gaussian_mu, Gaussian_Sigma, QUIET);
   		%fprintf(1, 'Iteration %d:\t%.3f\n', j, logl(j));
  		[Gaussian_mu, Gaussian_Sigma, Gaussian_w] = mix_par(featbyclass, gamma, DIAG_COV, QUIET);
   end;
   %[w,mu,Sigma] = mix(featbyclass,w,mu,Sigma,n_it);
   
   w(i,:) = Gaussian_w;
   m(:,:,i) = Gaussian_mu;
   C(:,:,i) = Gaussian_Sigma;
end;

