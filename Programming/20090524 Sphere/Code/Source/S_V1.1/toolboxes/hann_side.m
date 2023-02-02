% ----------------------------------------------------------------------------------------
% Function : hann_side.m
% 
% Purpose  : This function build a flat window with hann-shaped sides on overlapped parts.
%
%
% Inputs :  
%       N       [scalar] Window size
%       
%       shift   [scalar] shift percentage between windows (overlap = 1-shift)
%
% Outputs : 
%       window  [vector] built window
%       
%
%
% Author    : Pitch Corp.
% Date      : 07.06.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function window = hann_side(N, shift)

    %%% Build Hann window with size = 2*overlap
    overlap = N*(1-shift);
    h = hann(2*overlap, 'periodic');

    %%% Build Window with size L
    window = rectwin(N);

    %%% Modify raising and decay side
    window(1:overlap) = h(1:overlap);
    window(N-overlap+1 : N) = h(overlap+1 : 2*overlap);

end %function


% --------------------------------- End of file ------------------------------------------
