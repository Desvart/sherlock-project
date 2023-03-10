% Relev? des harmoniques principales pour P07 (T1800)
% h{x,y} : x = erreur
%          y = identifiant mvt (en fonction de l'erreur)

% La diff?rence entre le script V1 et V2 est que la version 2 prend en
% compte des labels pour notifier quelles sont les modes ascendants et
% descendants ainsi que les modes "longs".

% 13.03.2012

clear all;
close all;
clc;

harm{1, 1} =   [21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6; ...
                21.9, 14.8, 10.2, 8.2, 2.1, 1.6]';
hLegend{1, 1} =[ ' ',  ' ',  ' ', ' ', ' ', ' '];

harm{1, 2} =   [51.0, 40.4, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 00.0, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 40.4, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 00.0, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 40.4, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 00.0, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 40.4, 22.5, 14.5, 11.1, 2.1; ...
                51.0, 00.0, 22.5, 14.5, 11.1, 2.1]';
hLegend{1, 2} =[ ' ',  ' ',  ' ',  ' ',  ' ', ' '];

harm{1, 3} =   [00.0, 40.0, 00.0, 14.6, 2.3; ...
                51.0, 00.0, 22.1, 14.6, 2.3; ...
                00.0, 40.0, 22.1, 14.6, 2.3; ...
                51.0, 00.0, 22.1, 14.6, 2.3; ...
                00.0, 40.0, 22.1, 00.0, 2.3; ...
                51.0, 00.0, 00.0, 00.0, 2.3; ...
                00.0, 40.0, 00.0, 00.0, 2.3; ...
                51.0, 00.0, 22.1, 00.0, 2.3; ...
                ]';
hLegend{1, 3} =[ '-',  'L',  ' ',  ' ', ' '];


harm{2, 1} =   [00.0, 00.0, 00.0, 41.0, 38.3, 00.0, 00.0, 00.0, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 50.6, 00.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 50.6, 41.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 50.6, 00.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 50.6, 41.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 00.0, 00.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 50.6, 41.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6; ...
                56.8, 52.9, 50.6, 00.0, 38.3, 30.7, 28.1, 27.3, 22.1, 14.8, 2.3, 1.6]';
hLegend{2, 1} =[ ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  '+',  ' ',  ' ',  ' ', 'L', ' '];

harm{2, 2} =   [52.5, 00.0, 00.0, 25.4, 00.0, 23.8, 23.4, 00.0, 00.0, 2.1, 1.4; ...
                00.0, 30.9, 25.8, 00.0, 24.4, 00.0, 23.4, 14.6, 10.3, 2.1, 1.4; ...
                52.5, 00.0, 00.0, 25.4, 00.0, 23.8, 23.4, 14.6, 10.3, 2.1, 1.4; ...
                00.0, 30.9, 25.8, 00.0, 24.4, 00.0, 23.4, 14.6, 00.0, 2.1, 1.4; ...
                52.5, 00.0, 00.0, 25.4, 00.0, 23.8, 23.4, 14.6, 10.3, 2.1, 1.4; ...
                00.0, 30.9, 25.8, 00.0, 24.4, 00.0, 23.4, 14.6, 10.3, 2.1, 1.4; ...
                52.5, 00.0, 00.0, 25.4, 00.0, 23.8, 23.4, 00.0, 00.0, 2.1, 1.4; ...
                00.0, 30.9, 25.8, 00.0, 24.4, 00.0, 23.4, 14.6, 10.3, 2.1, 1.4]';
hLegend{2, 2} =[ ' ',  ' ',  '-',  '+',  '-',  '+',  ' ',  ' ',  ' ', ' ', ' '];

harm{2, 3} =   [65.0, 00.0, 00.0, 32.8, 22.7, 15.2, 11.3, 0.0, 2.1, 1.4; ...
                65.0, 63.9, 60.0, 32.8, 22.7, 15.2, 11.3, 9.4, 2.1, 1.4; ...
                65.0, 00.0, 00.0, 32.8, 22.7, 15.2, 11.3, 0.0, 2.1, 1.4; ...
                65.0, 63.9, 60.0, 32.8, 22.7, 15.2, 11.3, 9.4, 2.1, 1.4; ...
                65.0, 00.0, 00.0, 32.8, 22.7, 15.2, 11.3, 0.0, 2.1, 1.4; ...
                65.0, 63.9, 60.0, 32.8, 22.7, 15.2, 11.3, 9.4, 2.1, 1.4; ...
                65.0, 00.0, 00.0, 32.8, 22.7, 15.2, 11.3, 0.0, 2.1, 1.4; ...
                65.0, 63.9, 60.0, 32.8, 22.7, 15.2, 11.3, 9.4, 2.1, 1.4]';
hLegend{2, 3} =[ ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ', ' ', ' ', ' '];


harm{3, 1} =   [40.4, 31.8, 22.1, 21.9, 21.3, 15.0, 2.3, 1.6; ...
                00.0, 00.0, 22.1, 21.9, 00.0, 15.0, 2.3, 1.6; ...
                40.4, 00.0, 22.1, 21.9, 00.0, 15.0, 2.3, 1.6; ...
                40.4, 31.8, 22.1, 00.0, 00.0, 15.0, 2.3, 1.6; ...
                40.4, 31.8, 22.1, 00.0, 21.3, 15.0, 2.3, 1.6; ...
                40.4, 31.8, 22.1, 21.9, 00.0, 15.0, 2.3, 1.6; ...
                40.4, 31.8, 22.1, 00.0, 21.3, 15.0, 2.3, 1.6; ...
                40.4, 31.8, 22.1, 21.9, 21.3, 15.0, 2.3, 1.6]';
hLegend{3, 1} =[ ' ',  ' ',  ' ',  ' ',  '-',  'L', ' ', ' '];

harm{3, 2} =   [51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6; ...
                51.6, 31.2, 22.3, 20.1, 14.4, 14.1, 9.2, 8.2, 1.6]';
hLegend{3, 2} =[ ' ',  ' ',  ' ',  ' ',  'L',  ' ', ' ', ' ', ' '];

harm{3, 3} =   [00.0, 00.0, 22.6, 00.0, 00.0, 8.4, 2.1, 1.4; ...
                42.6, 40.0, 00.0, 14.4, 11.7, 8.4, 2.1, 1.4; ...
                42.6, 00.0, 22.6, 14.4, 11.7, 8.4, 2.1, 0.0; ...
                42.6, 40.0, 22.6, 14.4, 11.7, 8.4, 00, 1.4; ...
                42.6, 00.0, 00.0, 14.4, 11.7, 8.4, 2.1, 1.4; ...
                42.6, 00.0, 00.0, 00.0, 11.7, 8.4, 2.1, 1.4; ...
                42.6, 00.0, 22.6, 00.0, 11.7, 8.4, 2.1, 1.4; ...
                42.6, 40.0, 22.6, 14.4, 11.7, 8.4, 2.1, 1.4]';
hLegend{3, 3} =[ 'L',  'L',  ' ',  'L',  ' ', ' ', 'L', ' '];


harm{4, 1} =   [65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 00.0, 26.0, 24.4, 22.5, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 29.1, 00.0, 24.4, 22.5, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 00.0, 26.0, 24.4, 22.5, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 29.1, 00.0, 24.4, 22.5, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 00.0, 26.0, 24.4, 22.5, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 29.1, 00.0, 24.4, 22.5, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 00.0, 26.0, 24.4, 00.0, 14.6, 10.7, 2.1; ...
                65.4, 63.9, 63.3, 62.1,  43.0, 41.0, 31.2, 29.1, 00.0, 24.4, 22.5, 14.6, 10.7, 2.1]';
hLegend{4, 1} =[ ' ',  ' ',  ' ',  ' ',  'L',  'L',  ' ',  ' ',  '-',  ' ',  ' ',  'L',  ' ', 'L'];

harm{4, 2} =   [40.6, 30.9, 00.0, 00.0, 21.3, 15.0, 9.4, 2.1; ...
                00.0, 00.0, 00.0, 21.9, 00.0, 00.0, 9.4, 2.1; ...
                40.6, 00.0, 21.9, 00.0, 00.0, 15.0, 9.4, 2.1; ...
                40.6, 00.0, 21.9, 21.9, 00.0, 15.0, 9.4, 2.1; ...
                40.6, 30.9, 00.0, 00.0, 00.0, 15.0, 9.4, 2.1; ...
                00.0, 30.9, 21.9, 00.0, 00.0, 15.0, 9.4, 2.1; ...
                40.6, 00.0, 21.9, 00.0, 00.0, 15.0, 9.4, 2.1; ...
                40.6, 30.9, 00.0, 21.9, 00.0, 15.0, 9.4, 2.1]';
hLegend{4, 2} =[ 'L',  ' ',  ' ',  '+',  '-',  ' ', ' ', ' '];

harm{4, 3} =   [00.0, 30.9, 23.2, 22.3, 00.0, 9.4, 1.9, 1.4; ...
                40.0, 30.9, 23.2, 22.3, 14.4, 9.4, 1.9, 1.4; ...
                00.0, 30.9, 23.2, 22.3, 14.4, 9.4, 1.9, 1.4; ...
                40.0, 30.9, 23.2, 22.3, 14.4, 9.4, 1.9, 1.4; ...
                00.0, 30.9, 23.2, 22.3, 00.0, 9.4, 1.9, 1.4; ...
                40.0, 30.9, 23.2, 22.3, 00.0, 0.0, 1.9, 1.4; ...
                00.0, 30.9, 23.2, 22.3, 00.0, 9.4, 1.9, 1.4; ...
                40.0, 30.9, 23.2, 22.3, 14.4, 9.4, 1.9, 1.4]';
hLegend{4, 3} =[ 'L',  ' ',  ' ',  ' ',  'L', ' ', ' ', ' '];


figure('color', 'white');
hold on;

for errId = 1 : size(harm, 1),
    for fileId = 1 : size(harm, 2);
        for tocId = 1 : size(harm{errId, fileId}, 2),
            
            tocHarm = harm{errId, fileId}(:, tocId);
            tocLegend = hLegend{errId, fileId};
            for iHarm = 1 : size(harm{errId, fileId}, 1)
                
                if tocHarm(iHarm) > 0,
                    xId = (errId-1)*3 + fileId + 0.1*(tocId-1);
                    switch tocLegend(iHarm),
                        case ' ', colorPlot= 'b';
                                  formPlot = '.';
                        case 'L', colorPlot= 'r';
                                  formPlot = '.';
                        case '+', colorPlot= 'b';
                                  formPlot = '^';
                        case '-', colorPlot= 'b';
                                  formPlot = 'V';
                        
                    end
                    
                    plot(xId, tocHarm(iHarm), [formPlot, colorPlot]);
                end
                
                if tocId >= 5 && tocHarm(iHarm) > 0,
                    if sum(any(harm{errId, fileId} == tocHarm(iHarm))) >= 5,
                        line([(errId-1)*3 + fileId, (errId-1)*3 + fileId + 0.1*(size(harm{errId, fileId}, 2)-1)], [tocHarm(iHarm), tocHarm(iHarm)], 'color', colorPlot);
                    end
                end
                
            end
        end
    end
    
    sepLineIdx = (errId-1)*3 + fileId + 0.1*(size(harm{errId, fileId}, 2) + 2);
    line([sepLineIdx, sepLineIdx], [0, 100], 'color', 'k');
    xlim([0.9, 12.7])
end

xlabel('Class index (1-3 : ''Sans d?faut'' | 4-6 : ''Non lubrifi?'' | 7-9: ''Spiral d?centr?'' | 10-12 : ''Dents sur impulsion'')');
ylabel('Frequency [kHz]');