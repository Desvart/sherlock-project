clear all, close all, clc

% fo = fopen('.\Default1.mat');
% fread(fo,100)

file = load('.\Default3.mat');
y = file.SDefault_3;
fs = 51200;
[b,a] = butter(4,500/(fs/2),'high');
yf = double(filtfilt(b,a,y));

freqz(b,a,[],fs)

nfft = 1024;
win = hamming(nfft,'periodic');
noverlap = 0.75*nfft;
[S,F,T] = spectrogram(yf',win,noverlap,nfft,fs);

% figure;imagesc(T,F,20*log10(abs(S)./max(max(abs(S)))));axis xy
% figure;pcolor(T,F,20*log10(abs(S)./max(max(abs(S)))));axis xy; shading interp,colorbar
figure;surf(T,F,20*log10(abs(S)./max(max(abs(S))))); shading interp