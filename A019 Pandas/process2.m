% Plot toc
% 2012.03.28 - 2012.03.28


%% Init scipt

close all; 
% clear all; 
clc;

sigNum = 21;
stdMul = 3;
expCst = 0.05;
topFactor = 2;

%% Load signal

% load(['data/signal' num2str(sigNum) '.mat']);
signal = abs(signal(1:fs/4));

signal = signal ./ max(signal); % Signal normalization to 1
tAxis  = (0:length(signal)-1)/fs;

%%Core Pitchscript

energy   = signal.^2;
energyDb = 10*log10(energy);

%% Plot section

% figure('color', 'white');
% nSubplotRaw = 3;
% 
% %%% Subplot 1:1 : Time domain
% subplot(nSubplotRaw, 1, 1);
% hold on;
% 
% plot(tAxis*1e3, signal);
% 
% axis tight;
% 
% xlabel('Time [ms]');
% ylabel('Amplitude [-]');
% title('Raw signal');
% 
% 
% %%% Subplot 2:1 : energy domain (-)
% subplot(nSubplotRaw, 1, 2);
% hold on;
% 
% plot(tAxis*1e3, energy);
% 
% axis tight;
% % ylim([plotLevelDb, 0]);
% 
% xlabel('Time [ms]');
% ylabel('Energy [-]');
% title('Energy');
% 
% %%% Subplot 2:1 : energy domain (dB)
% subplot(nSubplotRaw, 1, 3);
% hold on;
% 
% plot(tAxis*1e3, energyDb);
% 
% axis tight;
% % ylim([plotLevelDb, 0]);
% 
% xlabel('Time [ms]');
% ylabel('Energy [dB]');
% title('Energy');

%%%
%%% end of neat & boring stuff :-P
%%%

%%%
%%% beginning of nasty stuff ^^
%%% sit tight and enjoy the ride !
%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Panda-powered algorithm

%% initialization
abssig = abs(signal);

% initialize window size
width2= 41;

%%% DO TWO MOVING STD.DEV

%%% blocks in the past -> std_
%%% blocks in the future -> stf_
%%% ... may god forgive me for such variable names

%%% stf/std is used to identify maximal change, that is, the start
%%% such values are contained in ratio_vec

% contains std dev
std_vec2= moving_std(signal,width2,'backward');

% contains std dev
stf_vec2= moving_std(signal,width2,'forward');

% approximate regions-of-interest vector
roi= stf_vec2 > (stdMul.*std_vec2);

% using width2
ratio_vec = stf_vec2./(std_vec2);
ratio_vec(1) = 1;

% "hey, it starts here!" vector
start = zeros(size(abssig));

% exponentially decreasing threshold vector
min_top = zeros(size(abssig));

i = 1;
roi_count = 0;
top_magn = 0;
top_last = 0;
while i < length(roi)
    if roi(i)==1
        
        roi_count = roi_count + 1;
        
        % identify start & end
        start_idx = i;
        while roi(i) == 1
            end_idx = i;
            i=i+1;
            min_top(i) = top_magn*exp(-expCst*(i-top_last));
        end
 
        if (end_idx-start_idx < 2)
                if(ratio_vec(end_idx)>ratio_vec(start_idx))
                    start_loc = 1;
                else
                    start_loc = 0;
                end    
        else
                % find exact start, look for peak in sqrt(avg future values/avg past values)
                [~,start_loc]=findpeaks(ratio_vec(start_idx:end_idx),'npeaks',1,'sortstr','descend');
        end
        
        if ratio_vec(start_idx+start_loc) > (top_magn*exp(-expCst*((start_idx+start_loc)-top_last)));
        
            top_magn = 2*ratio_vec(start_idx+start_loc);
            top_last = start_idx+start_loc;
            
            % set start on signal (bingo!)
            start(top_last) = 1;
            %display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx)]);
        end
    else
        i=i+1;
        min_top(i) = top_magn*exp(-expCst*(i-top_last));
    end
end

% plot everything
figure,
hold on;
plot(signal,'b');
plot(-0.5.*start,'r');
plot(0.5*roi,'k');
plot(0.01*ratio_vec+0.1,'c');
plot(0.01*min_top+0.1,'g');