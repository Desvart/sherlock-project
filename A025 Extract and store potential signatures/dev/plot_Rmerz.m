mvtId = 'ML156-02c';
barilletLevel = 1;
tocId = 6;


dsRequest    = strcmp(dsSignal.mvtId, mvtId) & dsSignal.barilletLevel == barilletLevel;
dsAnswer     = dsSignal(dsRequest, {'signal'});
signal       = double(dsAnswer.signal);

dsRequest    = strcmp(dsToc.mvtId, mvtId) & dsToc.barilletLevel == barilletLevel & dsToc.tocId == tocId-1;
dsAnswer     = dsToc(dsRequest, 9);
chuteS1       = double(dsAnswer);

dsRequest    = strcmp(dsToc.mvtId, mvtId) & dsToc.barilletLevel == barilletLevel & dsToc.tocId == tocId;
dsAnswer     = dsToc(dsRequest, 9);
chuteS       = double(dsAnswer);
dsAnswer     = dsToc(dsRequest, 4);
degS1       = double(dsAnswer);

dsRequest    = strcmp(dsToc.mvtId, mvtId) & dsToc.barilletLevel == barilletLevel & dsToc.tocId == tocId+2;
dsAnswer     = dsToc(dsRequest, 4);
degS         = double(dsAnswer);


%% Load signal
signal = (signal((chuteS1+2000):degS));
% signal   = load_signal('ML156-02c', 'B01', 'T02', [idxS1, idxS2]);
nSamples = length(signal);
xAxis    = (0:nSamples-1)/1e3; % kSamples

%% Apply a Simple Moving Average
windowsLength = 6000;
xStar     = [0, cumsum(signal)];
signalSma = [zeros(1, windowsLength-1), ( xStar(windowsLength+1:end) - xStar(1:end-windowsLength) ) / windowsLength];

%% Plot signal and average
figure('Color', 'white'); hold on;
plotyy(xAxis, signal, xAxis, db(signalSma), 'plot'); % Signal magnify by 500
xlabel('Samples [kS]');
ylabel('Amplitude [P]');
legend('Signal magnify by 500', 'Simple Moving Average (SMA) on 1000 samples in dB');
% axis tight;