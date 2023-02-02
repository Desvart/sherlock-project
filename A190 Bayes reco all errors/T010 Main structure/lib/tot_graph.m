classE00 = [1,2, 9,10, 17,18, 25:30];
classE01 = [3:4, 11:12, 19:20];
classE02 = [5:6, 13:14, 21:22];
classE03 = [7:8, 15:16, 23:24];
classE0x = sort([classE01, classE02, classE03]);

classB03 = 1:2:30;
classB06 = 2:2:30;

% [pValTicTacVal, pValTicTacId] = p_val_toc();
% [pValB03B06Val, pValB03B06Id] = p_val2(classB03, classB06);

dataPath = './data/dataset.mat';

[pValE00E0xVal, pValE00E0xId] = p_val2(dataPath, classE00, classE0x);
[pValE00E01Val, pValE00E01Id] = p_val2(dataPath, classE00, classE01);
[pValE00E02Val, pValE00E02Id] = p_val2(dataPath, classE00, classE02);
[pValE00E03Val, pValE00E03Id] = p_val2(dataPath, classE00, classE03);
[pValE01E02Val, pValE01E02Id] = p_val2(dataPath, classE01, classE02);
[pValE01E03Val, pValE01E03Id] = p_val2(dataPath, classE01, classE03);
[pValE02E03Val, pValE02E03Id] = p_val2(dataPath, classE02, classE03);




color = 'kgr';


% figure('Color', 'white');
% 
% subplot(7, 1, 1); 
% hold on;
% for i = 1 : 3,
%     plot(pValTicTacId{i}, pValTicTacVal{i}, ['*', color(i)]);
% end
% xlim([0, nSign]);
% title('Tic - Tac');
% 
% subplot(7, 1, 2); 
% hold on;
% for i = 1 : 3,
%     plot(pValB03B06Id{i}, pValB03B06Val{i}, ['*', color(i)]);
% end
% xlim([0, nSign]);
% title('B03 - B06');


nSign = 13;

figure('Color', 'white');

subplot(7, 1, 1); 
hold on;
for i = 1 : 3,
    plot(pValE00E0xId{i}, pValE00E0xVal{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E00 - E0x');

subplot(7, 1, 2);
hold on;
for i = 1 : 3,
    plot(pValE00E01Id{i}, pValE00E01Val{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E00 - E01');

subplot(7, 1, 3);
hold on;
for i = 1 : 3,
    plot(pValE00E02Id{i}, pValE00E02Val{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E00 - E02');

subplot(7, 1, 4);
hold on;
for i = 1 : 3,
    plot(pValE00E03Id{i}, pValE00E03Val{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E00 - E03');

subplot(7, 1, 5);
hold on;
for i = 1 : 3,
    plot(pValE01E02Id{i}, pValE01E02Val{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E01 - E02');

subplot(7, 1, 6);
hold on;
for i = 1 : 3,
    plot(pValE01E03Id{i}, pValE01E03Val{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E01 - E03');

subplot(7, 1, 7);
hold on;
for i = 1 : 3,
    plot(pValE02E03Id{i}, pValE02E03Val{i}, ['*', color(i)]);
end
xlim([0, nSign]);
title('E02 - E03');

