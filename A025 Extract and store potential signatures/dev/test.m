mvtId = 'ML156-01c';
barilletLevel = 1;
tocId = 6;
windowLength = 500;

load('visoBarilletDataset2.mat');

dsRequest    = strcmp(datasetSignal.mvtId, mvtId) & datasetSignal.barilletLevel == barilletLevel;
dsAnswer     = datasetSignal(dsRequest, {'signal', 'mvtFreq'});
signal       = double(dsAnswer.signal);
mvtFreq      = double(dsAnswer.mvtFreq);

dsRequest    = strcmp(datasetToc.mvtId, mvtId) & datasetToc.barilletLevel == barilletLevel & datasetToc.tocId == tocId-1;
dsAnswer     = datasetToc(dsRequest, {'degS', 'chuteS'});
degS0        = double(dsAnswer.degS);
chuteS0      = double(dsAnswer.chuteS);

dsRequest    = strcmp(datasetToc.mvtId, mvtId) & datasetToc.barilletLevel == barilletLevel & datasetToc.tocId == tocId;
dsAnswer     = datasetToc(dsRequest, {'degS', 'chuteS'});
degS1        = double(dsAnswer.degS);
chuteS1      = double(dsAnswer.chuteS);

dsRequest    = strcmp(datasetToc.mvtId, mvtId) & datasetToc.barilletLevel == barilletLevel & datasetToc.tocId == tocId+1;
dsAnswer     = datasetToc(dsRequest, {'degS', 'chuteS'});
degS2        = double(dsAnswer.degS);
chuteS2      = double(dsAnswer.chuteS);



%% Load signal

signal   = signal(chuteS0:degS2);
nSamples = length(signal);
xAxis    = (0:nSamples-1)/1e3; % kSamples


%% Perform simple moving standard deviation (SMSTD) (backward version)

smstd = zeros(1, nSamples);
for iSample = windowLength : nSamples,
    smstd(iSample) = std(signal(iSample-windowLength+1 : iSample));
end


%% Estimate noise level

altPerSec = mvtFreq / 3600;
nSamplesToEstimateNoiseLevel = round((degS1 - degS0) / 4);
signaleUsedToEstimateNoiseLevelDb = db(smstd(end-nSamplesToEstimateNoiseLevel:end));

smstdMeanDb  = mean(signaleUsedToEstimateNoiseLevelDb);
smstdStdDb   = std(signaleUsedToEstimateNoiseLevelDb);

noiseLevelDb = smstdMeanDb + 6*smstdStdDb;


%% Detect toc end

isNoise = db(smstd(chuteS1-chuteS0:end)) < noiseLevelDb;
tocEndIdx = find(isNoise, 1, 'first');



%% Plot signal and average

figure('Color', 'white'); hold on;

plot(xAxis, db(signal), 'Color', [0.8, 0.8, 0.8]);
axH = plotyy(xAxis, signal, xAxis, db(smstd), 'plot');
axes(axH(2)); hold on;
lineXAxisMean = [nSamples-nSamplesToEstimateNoiseLevel, nSamples]/1e3;
lineXAxisNoise = [chuteS1-chuteS0, nSamples]/1e3;
line(lineXAxisMean,  smstdMeanDb*[1, 1], 'Color', [0.8, 0, 0]);
line(lineXAxisNoise, noiseLevelDb*[1, 1], 'Color', [1, 0, 0]);
plot((chuteS1-chuteS0+tocEndIdx)/1e3, db(smstd(chuteS1-chuteS0+tocEndIdx)), '*r');


xLim = [0, nSamples/1e3];
set(axH(1), 'Xlim', xLim);
set(axH(2), 'Xlim', xLim);

xlabel('Samples [kS]');
set(get(axH(1), 'Ylabel'), 'String', 'Amplitude (relative) [Pa]');
set(get(axH(2), 'Ylabel'), 'String', 'Amplitude [dB]') ;

legend('Signal', 'Simple Moving STD (SM-STD) on 1000 samples');