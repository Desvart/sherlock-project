% 

% Author	: Pitch
% Dev. on   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64

% History
% [Major.Minor.Revision.Build]
% 0.0.a0.0000 - 2013.06.17



%% Clean Matlab environment
function [pValVal, pValId] = p_val2(datasetFileRPath, class1Sel, class2Sel)

    %% Script parameters

    %%% Data structure
    N_FILES             = 30;
    N_TOCS_PER_FILE     = 10;



    %% Init script

    %%% Start text
    fprintf('START STAT EXTRACTION\n\n');

    %%% Load 
    % ssh_extract_stat;
    % clear all;
    load(datasetFileRPath);



    %% Group vectors B03 and B06




    %%% Define variable to extract as caracteristic
    var  = {'dist56', 'max2', 'max5', 'max7', 'max4', 'max6', 'e0', 'e2', 'e4', 'e5', 'e6', ...
            'pit', 'nBounces'};
    %%% 

    carIdxArray = bsxfun(@plus, (1:5:N_TOCS_PER_FILE/2*N_FILES)'*ones(1, N_TOCS_PER_FILE/2), 0:4);
    % class1Sel = [5:6, 13:14, 21:22];
    class1Array = carIdxArray(class1Sel, :)';
    class1Array = class1Array(:);

    % class2Sel = [7:8, 15:16, 23:24];
    class2Array = carIdxArray(class2Sel, :)';
    class2Array = class2Array(:);

    %%% Prealloc
    class1 = nan(length(class1Sel)*10, 39);
    class2 = nan(length(class2Sel)*10, 39);

    vectIdx = 0; 

        for iVar = 1 : length(var),
            vectIdx     = vectIdx(end) + (1:2);
            a = eval(var{iVar});
            aClass1T = a(class1Array, :)';
            aClass2T = a(class2Array, :)';
            class1(:, iVar) = aClass1T(:);
            class2(:, iVar) = aClass2T(:);
        end

    mClass1 = nanmean(class1);
    sClass1 = nanstd(class1);
    mClass2 = nanmean(class2);
    sClass2 = nanstd(class2);

    class1SizeNan = size(class1, 1) - sum(isnan(class1));
    class2SizeNan = size(class2, 1) - sum(isnan(class2));

    welchTest = abs((mClass1 - mClass2)) ./ sqrt( (sClass1.^2)./class1SizeNan + (sClass2.^2)./class2SizeNan );

    vnX = sClass2./class2SizeNan;
    vpX = sClass1./class1SizeNan;
    df = ((vnX+vpX).^2)./((vnX.^2)./(class2SizeNan-1)+(vpX.^2)./(class1SizeNan-1));

    eVal = (1-tcdf(welchTest, df-1));
    bonferroniFact = max([size(class1, 1) - sum(isnan(class1)); size(class2, 1) - sum(isnan(class2))]);
    pVal = bonferroniFact.*eVal;

    p1Star = 5/100;
    pVal1Star = pVal < p1Star;
    pVal1StarVal = pVal(pVal1Star);

    p2Star = 1/100;
    pVal2Star = pVal < p2Star;
    pVal2StarVal = pVal(pVal2Star);

    p3Star = 1/1000;
    pVal3Star = pVal < p3Star;
    pVal3StarVal = pVal(pVal3Star);


    pValVal = {pVal1StarVal; pVal2StarVal; pVal3StarVal};
    pValId = {find(pVal1Star); find(pVal2Star); find(pVal3Star)};


    %% Clean Matlab environment

    fprintf('\n\nSTOP STAT EXTRACTION\n\n');

end


%%% eof
