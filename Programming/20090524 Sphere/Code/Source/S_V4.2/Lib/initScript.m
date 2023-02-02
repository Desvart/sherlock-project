% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Extract data from a wave-file. Data are in their native form but cast in double.
% According to specifications wave-file native form is 2^16 signed integer.
% (-2^15:2^15-1 == -32768:32767)
%
% Input
%   - filePath [str] File path
%
% Output
%   - signal [dbl 1xn] Signal extracted
%   - fs     [int 1x1] Signal sampling rate
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.09
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [learningParam,h] = initScript(db, learningParam, featExtractParam, reductParam, model, snr)

    %%% Compute nb crossvalidation for training strategy 1
    strategy = learningParam(1);
    if strategy == 0 || (strategy == 1 && learningParam(3) > db.nbFile), % Do all crossvalidation
        learningParam(3) = db.nbFile;
    end
    
    dispScriptSettings(db, learningParam, featExtractParam, reductParam, model, snr);

    % Build waitbar
    h = waitbar(0, ['Iteration : 1/',int2str(learningParam(3))], 'Name', 'Progression');
                    
    % Launch chrono
    tic;

end


% FUNCTION --------------------------------------------------------------------------------------- %
% Display script setting
% ------------------------------------------------------------------------------------------------ %

function dispScriptSettings(db, learningParam, featExtractParam, reductParam, model, snr)

    disp(' ');
    disp('Script settings');
    disp('----------------');
    
    if db.realFeatFlag,
        disp('Feature origin    : real physical data');
    else
        disp('Feature origin    : mathematically built');
    end
    
    nbFile = db.nbFile;
    nbCrossval = learningParam(3);
    switch learningParam(1),
        case 0, disp(['Training          : ',num2str(nbFile-1),' files (all - 1).']);
                disp( 'Testing           : 1 file (last one)');
                disp(['Crossvalidation   : ',num2str(nbCrossval),' (all)']);
        case 1, disp(['Training          : ',num2str(nbFile-1),' files (all - 1).']);
                disp( 'Testing           : 1 file (last one)');
                disp(['Crossvalidation   : ',num2str(nbCrossval)]);
        otherwise, 
                disp(['Training          : ',num2str(nbFile*learningParam(1)),' files (',num2str(learningParam(1)*100),'% of database files).']);
                disp(['Testing           : ',num2str(nbFile*(1-learningParam(1))),' files (',num2str(100-learningParam(1)*100),'% of database files).']);
                disp(['Crossvalidation   : ',num2str(nbCrossval)]);
    end
    
    if learningParam(2) == true,
        disp('Files selection   : random');
    else
        disp('Files selection   : sequential');
    end
    
    disp(['SNR               : ',num2str(snr(1)),' dB (training)']);
    disp(['                    ',num2str(snr(2)),' dB (testing)']);
    
    
    switch featExtractParam(1),
        case 1, disp(['Feature selected  : Spectrogramm - N = ',num2str(featExtractParam(2))]);
                disp(['                                   S = ',num2str(featExtractParam(3))]);
        case 2, disp(['Feature selected  : MFCC (',')']);
    end
    
    disp(['Feature reduction : PCA = ',num2str(reductParam(1))]);
    disp(['                    LDA = ',num2str(reductParam(2))]);
    disp(' ');
    switch model(1),
        case 1, disp( 'Model selected    : Bayes');
        case 2, disp(['Model selected    : GMM - nbGMM = ',num2str(model(2))]);
                disp(['                          EMTol = ',num2str(model(3))]);
    end
    
    %%%
    disp(' ');
    disp('Script initialization : ............................................................ OK');
    disp(' ');
    disp(' ');
    disp('--------------- Start Crossvalidation Loop ---------------');
    
end


% EoF -------------------------------------------------------------------------------------------- %

