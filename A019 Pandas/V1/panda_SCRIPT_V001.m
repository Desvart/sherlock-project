% Plot toc
% 2012.03.28 - 2012.03.28


%% Init scipt

close all; clear all; clc;


file = 'toc2.mat';

%% Load signal

if strcmp(file,'toc.mat')
    load('toc.mat');
    signal = tocSignal;
else
    load('toc2.mat');
end

signal = signal ./ max(signal); % Signal normalization to 1
tAxis  = (0:length(signal)-1)/fs;

%%Core Pitchscript

energy   = signal.^2;
energyDb = 10*log10(energy);

%% Plot section

figure('color', 'white');
nSubplotRaw = 3;

%%% Subplot 1:1 : Time domain
subplot(nSubplotRaw, 1, 1);
hold on;

plot(tAxis*1e3, signal);

axis tight;

xlabel('Time [ms]');
ylabel('Amplitude [-]');
title('Raw signal');


%%% Subplot 2:1 : energy domain (-)
subplot(nSubplotRaw, 1, 2);
hold on;

plot(tAxis*1e3, energy);

axis tight;
% ylim([plotLevelDb, 0]);

xlabel('Time [ms]');
ylabel('Energy [-]');
title('Energy');

%%% Subplot 2:1 : energy domain (dB)
subplot(nSubplotRaw, 1, 3);
hold on;

plot(tAxis*1e3, energyDb);

axis tight;
% ylim([plotLevelDb, 0]);

xlabel('Time [ms]');
ylabel('Energy [dB]');
title('Energy');

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

% compute energy histogram, so we know what's useless
[n,x] = hist(energy,512)
n = n./sum(n)

% 99% of the signal is basically useless, high energy is very limited
thresh = x(1);
i = 1;
while sum(n(1:i)) < 0.99
    i = i+1;
    thresh = x(i);
end
% original magical constant ->
roi_lower_bound = 0.01
% computed value, almost as good, but not quite ->
% roi_lower_bound = thresh

% initialize moving average
width = 20;

%%% DO TWO MOVING AVERAGES

%%% blocks in the past -> accu
%%% blocks in the future -> diff
%%% ... may god forgive me for such variable names

%%% diff is used to identify ROIs

%%% sqrt(diff/accu) is used to identify maximal change, that is, the start
%%% such values are contained in ratio_vec

% contains past average
accu = sum(abssig(1:width))/width;
accu_vec = zeros(size(abssig));

% contains future average
diff = sum(abssig(width+(1:width)))/width;
diff_vec = zeros(size(abssig));

% approximate regions-of-interest vector
roi = zeros(size(abssig));

% identify regions of interest & starting points
for i=(width+1):(length(abssig)-width)
    
    % is area not-boring? (moving average is above noise level)
    % magic value based on histogram, most values are <0.005, 3x for margin
    % can be generated automagically, but I couldn't be bothered to do it
    if diff > roi_lower_bound
        roi(i-20) = 1;
    end
    
    diff = diff + (abssig(i+width)-abssig(i))/width;
    diff_vec(i) = diff;
    accu = accu + (abssig(i)-abssig(i-width))/width;
    accu_vec(i) = accu;
end

ratio_vec = sqrt(diff_vec./accu_vec);

% dilate roi, if you fancy, I don't
% width = 20;
% dil_roi = roi;
% accu = sum(roi(1:width));
% for i=(width+1):(length(abssig)-1)
%     if accu > 0
%         dil_roi(i) = 1;
%     end
%     accu = accu + (roi(i+1)-roi(i-width));
% end
% roi = dil_roi;

%% find each roi and operate on it

% "here's da peak" vector
peaks = zeros(size(abssig));

% "hey, it starts here!" vector
start = zeros(size(abssig));

i = 1;
roi_count = 0;
while i < length(roi)
    
    % found a roi
    if roi(i)==1
        
        roi_count = roi_count + 1;
        
        % identify start & end
        start_idx = i;
        while roi(i) == 1
            end_idx = i;
            i=i+1;
        end
        
        %%%% HACK TO SKIP "WRONG" ROI PROBLEM
        if (end_idx - start_idx) < 200 % they're small, that's convenient
            roi_count = roi_count -1 ;
            roi(start_idx:end_idx) = zeros(1,end_idx-start_idx+1);
            continue;
        end
        %%%%
        
        % find exact start, look for peak in sqrt(avg future values/avg past values)
        [~,start_loc]=findpeaks(ratio_vec(start_idx:end_idx),'npeaks',1,'sortstr','descend');

        % set start on signal (bingo!)
        start(start_loc+start_idx) = 1;
        
        % find peaks, write it yourself if you bother... and I'm sure you do :-)
        [val,loc]=findpeaks(energy(start_idx:end_idx),'npeaks',1,'sortstr','descend');

        % set peaks on signal
        peaks(loc+start_idx) = 1;
        
        % echo our success !
        display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx) ' has peak of ' num2str(val) ' at idx: ' num2str(loc+start_idx)]);
    else
        i=i+1;
    end
end

% plot everything
figure,
hold on;
plot(signal,'b');
plot(start,'g');
plot(-0.5.*roi,'r');
plot(peaks,'k');
plot(diff_vec,'c');
plot(accu_vec,'y');