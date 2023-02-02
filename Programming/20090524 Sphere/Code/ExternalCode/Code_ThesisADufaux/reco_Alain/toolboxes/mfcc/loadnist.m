%==================================================================
% Load a signal with SPHERE header (NIST format) into MATLAB.
%
% The signal can be PCM or ULAW encoded. If the signal is 
% compressed by SHORTEN, it will be decompressed. The byte order
% will be properly swapped depending on the current machine.
% 
%  Usage:      Sig = LoadNIST('FName'); 
%
%  Example:   Sig = LoadNIST('sa1.wav');
%    
%   This command loads 'sa1.wav' (from TIMIT) into Sig. 
%------------------------------------------------------------------
%  Author  :  Jialong HE
%  Date    :  June 25, 1999
%==================================================================
