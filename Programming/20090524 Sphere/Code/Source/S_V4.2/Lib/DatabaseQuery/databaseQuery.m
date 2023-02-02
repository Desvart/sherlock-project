% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Extract features from database or generate mathematically modeled features and display database
% statistics in "Command Windows".
%
% Input
%   - dbPath [str]      Database path
%   - snr    [int 1x2]  Training and testing SNR
%   - featExtractParam [1xn] Parameters for feature extraction methods
%   - file2plot [bool 1x1 or cell] Relative files index to plot
%
% Output
%   - db [struct]   Contains data, label and somes data properties.
%                   .nbClass    [int 1x1] number of class in database
%                   .className  [cell cx1, str] Name of each class
%                   .nbFile     [int 1x1] number of file in all database
%                   .nbFileC    [int 1xc] number of file per class
%                   .dim        [int 1x1] dimension of features
%
%                   .trFeat     [dbl dxn] training feature data
%                   .trLabel    [int 1xn] label for each training feature
%                   .nbTrFeat   [int 1x1] number of training feature in all database
%                   .nbTrFeatC  [int 1xc] number of training feature per class
%                   .nbTrFeatF  [int 1xf] number of training feature per file
%
%                   .teFeat     [dbl dxn] testing feature data
%                   .teLabel    [int 1xn] label for each testing feature
%                   .nbTeFeat   [int 1x1] number of testing feature in all database
%                   .nbTeFeatC  [int 1xc] number of testing feature per class
%                   .nbTeFeatF  [int 1xf] number of testing feature per file
%
%                   .realFeatFlag [bool 1x1] if true, features come from mathematical models,
%                                            else they come from real physical data.
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.10
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function db = databaseQuery(dbPath, snr, featExtractParam, file2plot)

    display('Data extraction from database in progress : please wait...');

    %%% Extract feature from database
    if ischar(dbPath),
        db = extractDatabaseFeat(dbPath, snr, featExtractParam);
    else
        db = generateFeat(dbPath, file2plot);
    end
    
    %%% Display database statistics
    dispDbStat(db);
    
    %%% Plot raw features
    if iscell(file2plot),
        plotFeat(db, file2plot);
    end
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Display database statistics
% ------------------------------------------------------------------------------------------------ %

function dispDbStat(db)

    disp(' ');
    disp('Database statistics');
    disp('--------------------');

    str1 = num2str(db.className{1});
    str2 = num2str(db.nbFileC(1));
    str3 = num2str(db.nbTrFeatC(1));
    for cid = 2 : db.nbClass,
        str1 = [str1,' - ',num2str(db.className{cid})];  %#ok<AGROW>
        str2 = [str2,' - ',num2str(db.nbFileC(cid))];    %#ok<AGROW>
        str3 = [str3,' - ',num2str(db.nbTrFeatC(cid))];  %#ok<AGROW>
    end 
    display(['#class    : ',num2str(db.nbClass),' (',str1,')']);
    display(['#files    : ',num2str(db.nbFile),' (',str2,')']);
    display(['#features : ',num2str(db.nbTrFeat),' (',str3,')']);
    display(['dim       : ',num2str(db.dim)]);
    display( ' ');
    
    name = fieldnames(db);
    disp(['Database field names [',num2str(length(name)),' fields]:']);
%     disp(name);
%     disp(name([1:5,16])');
%     disp(name(6:10)');
%     disp(name(11:15)');
    fprintf('%s - %s - %s - %s - %s - %s - %s\n', name{1}, name{2}, name{3}, name{4}, name{5}, name{6}, name{7});
    fprintf('%s - %s - %s - %s - %s\n', name{7+1}, name{7+2}, name{7+3}, name{7+4}, name{7+5});
    fprintf('%s - %s - %s - %s - %s\n\n', name{7+5+1}, name{7+5+2}, name{7+5+3}, name{7+5+4}, name{7+5+5});
    
    disp( 'Database extraction : ............................................................. OK');

end


% FUNCTION --------------------------------------------------------------------------------------- %
% Plot raw features
% ------------------------------------------------------------------------------------------------ %

function plotFeat(db, file2plot)
    
    for cid = 1:length(file2plot),
        for rfid = file2plot{cid},
            
            fid = sum(db.nbFileC(1:cid-1)) + rfid;
            start = sum(db.nbTrFeatF(1:fid-1)) + 1;
            stop  = start + db.nbTrFeatF(fid) - 1;
            feat  = db.trFeat(:,start:stop);
            
            figure('color', 'w');
            pcolor(feat);
            title(['Class ',num2str(cid), ' file ', num2str(rfid)]);
            
        end
    end
    
end


% EoF -------------------------------------------------------------------------------------------- %
