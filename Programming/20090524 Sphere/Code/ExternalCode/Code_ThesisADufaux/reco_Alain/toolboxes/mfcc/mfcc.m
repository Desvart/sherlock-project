%==================================================================
% Calculate Mel-scaled FFT based cepstrum (MFCC) for a given signal.
%
% MFCC parameters are given by a structure. The field names
% of the structure are defined as below.
% 
%   Analysis parameters:
%
%    (1) Par.Order : Number of MFCC coefficients.
%    (2) Par.Delta : Delta MFCC, 1: Yes, 0: No.
%    (3) Par.WinSz : Analysis window size.
%    (4) Par.StpSz : Window moving step.
%    (5) Par.SRate : Sampling rate.
%    (6) Par.RmvSilence : Remove silence, 1: Yes, 0: No;
%
% The calculated result is stored in a structure with field name "Mat". 
%
%  Usage: Cep = MFCC(Sig, Par); 
%
%  Example:
%
%      F_Par.Order   = 2;  % only two coefficients
%      F_Par.Delta   = 0;  % No Delta MFCC
%      F_Par.WinSz   = 256;
%      F_Par.StpSz   = 128;
%      F_Par.SRate   = 16000;
%      F_Par.RmvSilence = 1;  
%
%      M(1) = MFCC(Sig, F_Par);
%
%      Each row in M(1).Mat is a feature vectors.		 
%------------------------------------------------------------------
%  Author  :  Jialong HE
%  Date    :  June 25, 1999
%==================================================================
