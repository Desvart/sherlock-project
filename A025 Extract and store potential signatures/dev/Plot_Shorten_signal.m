FILE_NAME_TO_LOAD = 'visoBarilletDataset2.mat';
load(FILE_NAME_TO_LOAD);


s2 = [];

for iMvtId = 1 : 1,
    
     mvtId = ['ML156-0', int2str(iMvt), 'c'];
     
    for iBarilletLevel = 3,
        
        %%% Load signal
        mvtRequest           = strcmp(datasetSignal.mvtId, mvtId);
        barilletLevelRequest = datasetSignal.barilletLevel == iBarilletLevel;
        dsRequest            = mvtRequest & barilletLevelRequest;
        dsAnswer             = datasetSignal(dsRequest, {'signal', 'fs'});
        signal               = dsAnswer.signal;
        fs                   = dsAnswer.fs;

        %%% Load tags
        mvtRequest           = strcmp(datasetToc.mvtId, mvtId);
        barilletLevelRequest = datasetToc.barilletLevel == iBarilletLevel;
        dsRequest            = mvtRequest & barilletLevelRequest;
        degSArray            = double(datasetToc(dsRequest, {'degS'}));
        impSArray            = double(datasetToc(dsRequest, {'impS'}));
        chuteSArray          = double(datasetToc(dsRequest, {'chuteS'}));
        tocEndArray          = double(datasetToc(dsRequest, {'tocEnd'}));

        %%% Cut unused signal
        for iToc = 1 : 12,
            
            s2 = [s2, signal(degSArray(iToc):tocEndArray(iToc))];
            
        end
    end
end

figure;
plot(s2);
