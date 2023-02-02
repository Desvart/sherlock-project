% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Inputs : []  
%
% Outputs
%   - loopLog [array 1xit, struct] Contains all relevant data computed during each crossvalidation
%                                  loop. Each array element contains the data related to one
%                                  crossvalidation.
%                       .trFileId    [int 1xn] Training file id
%                       .teFileId    [int 1xm] Testing file id
%                       .model       [struct] Depend of selected model. See training related
%                                             function for more details.
%                       .membership  [int 1xm] Membership of testing feature after testing process.
%                       .certainties [dbl 1xm] Membership certainties of testing feature after
%                                              testing process.
%                       .stepConfMat [int cxc] Confusion matrix of a given crossvalidation loop
%                       .globConfMat [int cxc] Global confusion matrix of learning process.
%                       .stepPerf    [dbl 1x1] Performance of a given crossvalidation loop.
%                       .globPerf    [dbl 1x1] Global performance of learning process.
%                       .toc         [dbl 1x1] Time for each crossvalidation loop since beginning of
%                                              learning process.
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.09
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [learningLog, chrono] = learning_loop()
% LEARNING_LOOP  
%
% Synopsis:     generate_raw_feature_from_math_model()

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.05  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


end


% EoF -------------------------------------------------------------------------------------------- %
