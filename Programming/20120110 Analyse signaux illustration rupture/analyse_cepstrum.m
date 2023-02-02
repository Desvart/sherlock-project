

close all;
clc;
clear all;

addpath('./Lib/');

folderPath = '../../Data/20111100_Witschi_DB1/P09/V1.2';
[filePathList, nFileTot] = load_file_path_list(folderPath);
for iFile = 1:nFileTot,
%     iFile = 1;
    
    
    matObj = matfile(filePathList{iFile});
    
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 1:fs);
    
    
    [stdft, tAxis, fAxis] = stdft_(signal, sqrt(hann(1024, 'periodic')), 1/16, fs) ;
    [cepstrum, env, fin] = cepstrum_(stdft, 20);
    
    norm    = max(max(stdft));
    stdft   = stdft./norm;
    env     = env./norm;
    fin     = fin./norm;
    
    
    plotThese = find(db(stdft) >= -50);  
    t = repmat(tAxis, size(stdft, 1), 1);
    f = repmat(fAxis', 1, size(stdft, 2));
    
    
    plotThesefin = find(db(fin) >= 1.5*mean(mean(db(fin))));  
    fin2 = fin(plotThesefin);
    tfin = t(plotThesefin);
    ffin = f(plotThesefin);
    
    plotTheseenv = find(db(env) >= 0.8*mean(mean(db(env))));  
    env2 = env(plotTheseenv);
    tenv = t(plotTheseenv);
    fenv = f(plotTheseenv);
    
%     figure;
%     subplot(1,2,1);
% %     pcolor(tAxis*1e3, fAxis/1e3, db(stdft)); shading flat;
%     mesh(tAxis*1e3, fAxis/1e3, db(stdft)); shading flat;
%     view(0, 90);
%     subplot(1,2,2);
% %     pcolor(tAxis*1e3, fAxis/1e3, db(cepstrum)); shading flat;
%     mesh(tAxis*1e3, fAxis/1e3, db(cepstrum)); shading flat;
%     view(0, 90);
%     subplot(2,2,3);
% %     pcolor(tAxis*1e3, fAxis/1e3, db(env)); shading flat;
%     mesh(tAxis*1e3, fAxis/1e3, db(env)); shading flat;
%     scatter3(tenv(:)*1e3, fenv(:)/1e3, db(env2(:)), 4, db(env2(:)), 'filled');
%     view(0, 90);
%     subplot(2,2,4);
% %     pcolor(tAxis*1e3, fAxis/1e3, db(fin)); shading flat;
%     mesh(tAxis*1e3, fAxis/1e3, fin); shading flat;
%     scatter3(tfin(:)*1e3, ffin(:)/1e3, db(fin2(:)), 4, db(fin2(:)), 'filled');
%     view(0, 90);
    
%     pause;
%     
    h = figure('color', 'white');
    mesh(tAxis*1e3, fAxis/1e3, db(fin)); shading flat;
    view(0, 90);
    
    saveas(h, ['.\cepstrum_fin\cepstrum_fin_', filePathList{iFile}(end-27:end-4)]);
    
    mesh(tAxis*1e3, fAxis/1e3, db(env)); shading flat;
    view(0, 90);
    
    saveas(h, ['.\cepstrum_env\cepstrum_env_', filePathList{iFile}(end-27:end-4)]);
    
    close(h);
    
end


rmpath('./Lib/');