function [signal, fs] = extract_signal_from_file(filePath)
% EXTRACT_SIGNAL_FROM_FILE  Extract data from a wave-file. Data are in their native form but cast in
% double. According to specifications wave-file native form is 2^16 signed integer.
% (-2^15:2^15-1 == -32768:32767)
%
% Input
%   - filePath [str] File path
%
% Output
%   - signal [dbl 1xn] Signal extracted
%   - fs     [int 1x1] Signal sampling rate

% Project Sphere: Alpha 0.5.0
% Author: Pitch Corp.  -  2011.01.03  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


    % Extract data in their native form
    [signal, fs] = wavread(filePath, 'native');
    
    % Cast data and put it in line
    signal = double(signal');
    
end


% EoF -------------------------------------------------------------------------------------------- %
