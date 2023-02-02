
%%% Create mat object
% This file should exist before creating the object. If needed create it before.
% If you want to write in this file add 'Writable',true to the fonction matfile.
matObj = matfile('Data/msg.mat');
matObj = matfile('Data/msg.mat', 'Writable', true);

%%% Read data
% If mat object has been saved in version 7.3 or later, then only the selected values are loaded in
% memory. If not, then all values are loaded in memory and the discarded.
a = matObj.var1(2:45);

%%% Extract variable size without loading the variable
[nrows, ncols] = size(matObj, 'var1');

%%% Write variable
matObj.savedVar(5:10, 6:11) = rand(5, 5);
