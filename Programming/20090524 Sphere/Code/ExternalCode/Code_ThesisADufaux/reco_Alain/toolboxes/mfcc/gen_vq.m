%==================================================================
%  Generate a VQ codebook by the K-means algorithm.
%
%   The training parameters are given by a structure defined as:
%
%	(1) Par.Size     : codebook size
%	(2) Par.MaxIter  : maximum iterations 
%	(3) Par.RandSeed : random seed;
%
%
%  Usage:  CBook = Gen_VQ(Data, Par); 
%
%  Example:
%
%      suppose Data(1).Mat, Data(2).Mat, ...., contain training data,
%
%      MyPar.Size     = 8;   % 8 code vectors
%      MyPar.MaxIter  = 20;  
%      MyPar.RandSeed = 1973;
%
%      VQ = Gen_Vq(Data, MyPar);
%
%      Each row of VQ.Mat is a code vector.		 
%------------------------------------------------------------------
%  Author  :  Jialong HE
%  Date    :  June 25, 1999
%==================================================================
