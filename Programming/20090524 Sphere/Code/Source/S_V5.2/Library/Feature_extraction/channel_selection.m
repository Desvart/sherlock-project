function output = channel_selection(channelName)
% CHANNELSELECTION	Give the frequencies of each channel for some standard frequencies
%                   reprensentation.
%
% Synopsis: channelSelection(channelType)
%
% Inputs:   channelType  =  [str 1xm] This is a string that reprensent the type of channel to 
%                           select. It canhave 3 different values: 'None', 'Bark' and 'Uniform'.
%
% Output:   channel      =  [dbl 1xn] Array with all channel frequencies.

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    channel(1).name = 'Bark';
    channel(1).vect = [0, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, ...
                          2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, ...
                          15500, 21000];
                      
	channel(2).name = 'Uni500';
    channel(2).vect = 0:500:48e3;

    channel(3).name = 'Uni2000';
    channel(3).vect = 0:2000:48e3;
    
    
    
    
    
    
    
    nChannel = length(channel);
    output = cell(nChannel, 1);
    if nargin == 0,
        for iChannel = 1 : nChannel,
           output{iChannel} = channel(iChannel).name;
            
        end
    end
        
    if nargin == 1,
        for iChannel = 1 : nChannel,
           if strcmpi(channel(iChannel).name, channelName),
               output = channel(iChannel).vect;
               break;
            
            end
        end
    end

end 