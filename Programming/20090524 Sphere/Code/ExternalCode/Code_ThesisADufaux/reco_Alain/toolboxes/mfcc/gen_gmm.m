%==================================================================
% Generate a Gaussian Mixture Model (GMM) by the EM algorithm.
%
%  The parameters are given with a structure defined as:
%
%	(1) Par.Size     : number of Gaussian functions
%	(2) Par.MaxIter  : maximum iterations 
%	(3) Par.RandSeed : random seed;
%
%
%  Usage:  Model = Gen_GMM(Data, Par); 
%
%  Example:
%
%      suppose Data(1).Mat, Data(2).Mat, ...., contain training data,
%
%      MyPar.Size     = 8;
%      MyPar.MaxIter  = 20;
%      MyPar.RandSeed = 1973;
%
%      GMM = Gen_GMM(Data, MyPar);
%
%      Each row of GMM.MeanMat is a mean vector. 		 
%      Each row of GMM.VariMat is a variance vector.		 
%      GMM.WgtMat contains mixture weigth.
%------------------------------------------------------------------
%  Author  :  Jialong HE
%  Date    :  June 25, 1999
%==================================================================
