% Test Hilbert transform with chirp signal
close all; clear all; clc;

%%% Generate chirp signal
fs = 200e3; % kHz
d  = 1/4; % s
fLim = [500, 60e3, 30e3]; % Hz
ALim = [5, 1, 10]; % V

nSignal = fs * d;

% fRes = [(fLim(2)-fLim(1))/(nSignal/2), (fLim(3)-fLim(2))/(nSignal/2)];
% f    = [fLim(1):fRes(1):fLim(2)-fRes(1), (fLim(2):fRes(2):fLim(3)-fRes(2)) + fLim(2)+fLim(3)];

fRes = (fLim(2)-fLim(1))/(nSignal);
f    = fLim(1):fRes:fLim(2)-fRes;

ARes = [(ALim(2)-ALim(1))/(nSignal/2), (ALim(3)-ALim(2))/(nSignal/2)];
A1   = [ALim(1):ARes(1):ALim(2)-ARes(1), ALim(2):ARes(2):ALim(3)-ARes(2)];
A2   = ones(1, nSignal);

t    = (0 : nSignal-1)/fs;
A3   = sin(2*pi*3*t+3*pi/4);

chirp = A2.*sin(pi*f.*t);

stdftN = 1024;
stdftS = 1/4;
[stdft, tAxis, fAxis] = stdft_(chirp, sqrt(hann(stdftN, 'periodic')), stdftS, fs);
% [stdft, fAxis, tAxis, P] = spectrogram(chirp, sqrt(hann(stdftN, 'periodic')), (1-stdftS)*stdftN, stdftN, fs);

figure;
subplot(4,1,1:3);
mesh(tAxis*1e3, fAxis/1e3, stdft); shading flat; view([0, 90]);
subplot(4,1,4);
plot(t*1e3, chirp);



hilb = hilbert(chirp);
% fh = phase(hilb);
fh = diff(unwrap(angle(hilb)))./diff(t)/(2*pi);
fh2 = angle(hilb(2:nSignal).*conj(hilb(1:nSignal-1)))/2/pi*fs;       % mult by Fs to get Hertz


Ah  = abs(hilb);

fhm = running_mean(fh, 20, false);

figure; hold on;
% plot(t(2:end), fh);

plot((2:nSignal)/1e3, fh2/1e3, 'r');
plot((2:nSignal)/1e3, fh/1e3);
% plot((2:nSignal)/1e3, fhm/1e3, 'r');
% plot((1:nSignal)/1e3, Ah, 'g');
