%==================================================================
%  Generate continuous density hidden Markov model (HMM).
%
%  Training parameters are defined as:
%
%	(1) Par.Size     : number of Gaussian mixtures in each state
%	(2) Par.MaxIter  : maximum iterations 
%	(3) Par.RandSeed : random seed
%	(4) Par.NState   : number of states
%	(5) Par.Conf     : model structure, 
%      
%   For example, 3 states left-to-right model,
%    Par.Conf = [1, 1, 0; 0, 1, 1; 0, 0, 1];
%
%
%  Usage:  Model = Gen_CHMM(Data, Par); 
%
%  Example:
%
%      suppose Data(1).Mat, Data(2).Mat, ...., contain training data,
%
%      MyPar.Size     = 8;
%      MyPar.MaxIter  = 20;  
%      MyPar.RandSeed = 1973;
%      MyPar.NState   = 3;
%      MyPar.Conf     = [1, 1, 1; 1, 1, 1; 1, 1, 1];
%
%      HMM = Gen_CHMM(Data, MyPar);
%
%      HMM.Tran     : transition matrix. 		 
%      HMM.MeanMat  : mixture mean vectors. 		 
%      HMM.VariMat  : mixture variance vectors.		 
%      HMM.WgtMat   : mixture weight.
%------------------------------------------------------------------
%  Author  :  Jialong HE
%  Date    :  June 25, 1999
%==================================================================
