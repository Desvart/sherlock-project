close all;
clear all;
clc;

DATABASEPATH = 'd:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Database\Sounds\20111100_ARH\ARH_DB4_2\';

NFILE  = 8*12 + 1*8;
NFIELD = 12;



%% Case 1 : matObjList = SHH_get_matObj();
[matObj, nFileSelected] = SHH_get_matObj_A2();

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == NFILE;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == NFILE;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough field in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end


%% Case 2.1 :   matObjList = SHH_get_matObj(fileSelectionList);
fileSelectionList = [];
[matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList);

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == NFILE;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == NFILE;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough filed in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end


%% Case 2.2 :   matObjList = SHH_get_matObj(fileSelectionList);
fileSelectionList = [1, 2];
[matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList);

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == length(fileSelectionList)/2;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == 1;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough filed in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the right signal
test = (matObj{1}.signal(1, 2*matObj{1}.fs) - 1.7624e-4 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end


%% Case 2.2 :   matObjList = SHH_get_matObj(fileSelectionList);
fileSelectionList = [1, 2];
[matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList);

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == length(fileSelectionList)/2;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == nFile;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough filed in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the right signal
test = (matObj{1}.signal(1, 2*matObj{1}.fs) - 1.7624e-4 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end


%% Case 2.4 :   matObjList = SHH_get_matObj(fileSelectionList);
% fileSelectionList = [5,11; 5,12; 9,5]; 
% [matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList);
% 
% %%% is a cell array
% test = iscell(matObj);
% if test == false, error('Test failed.'); end
% 
% %%% is there enough cells in the cell array
% nFile = length(matObj);
% test  = nFile == length([fileSelectionList{:}]);
% if test == false, error('Test failed.'); end
% 
% %%% is nFileSelected correct
% test  = nFileSelected == NFILE;
% if test == false, error('Test failed.'); end
% 
% %%% is it the good object in each cells
% subtest = zeros(1, nFile);
% for iFile = 1 : nFile,
% 	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
% end
% test = ~any(~subtest);
% if test == false, error('Test failed.'); end
% 
% %%% is there enough filed in 
% subtest = zeros(1, nFile);
% for iFile = 1 : nFile,
%     subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
% end
% test = ~any(~subtest);
% if test == false, error('Test failed.'); end
% 
% %%% is it the right signal
% test = (matObj{1}.signal(1, 2*matObj.fs) - 0.0011 < 1e-8);
% if test == false, error('Test failed.'); end
% test = (matObj{2}.signal(1, 2*matObj.fs) - 1.0761e-4 < 1e-8);
% if test == false, error('Test failed.'); end
% test = (matObj{3}.signal(1, 2*matObj.fs) - -0.0047 < 1e-8);
% if test == false, error('Test failed.'); end


%% Case 3.1 : [matObj, nFileSelected] = SHH_get_matObj(fileSelectionList, databasePath);
fileSelectionList = {[], [], [], [], [11, 12], [], [], [], [5]};
[matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList, DATABASEPATH);

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == length([fileSelectionList{:}]);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == nFile;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough filed in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the right signal
test = (matObj{1}.signal(1, 2*matObj{1}.fs) - 0.0011 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end
test = (matObj{2}.signal(1, 2*matObj{2}.fs) - 1.0761e-4 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end
test = (matObj{3}.signal(1, 2*matObj{3}.fs) - -0.0047 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end


%% Case 3.2 : [matObj, nFileSelected] = SHH_get_matObj(fileSelectionList, databasePath);
fileSelectionList = {[], [], [], [], [11, 12], [], [], [], [5]};
[matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList, '../ARH_DB4_2/');

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == length([fileSelectionList{:}]);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == nFile;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough filed in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the right signal
test = (matObj{1}.signal(1, 2*matObj{1}.fs) - 0.0011 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end
test = (matObj{2}.signal(1, 2*matObj{2}.fs) - 1.0761e-4 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end
test = (matObj{3}.signal(1, 2*matObj{3}.fs) - -0.0047 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end


%% Case 4 : [matObj, nFileSelected] = SHH_get_matObj(fileSelectionList, databaseFlag, verboseFlag);
fileSelectionList = {[], [], [], [], [11, 12], [], [], [], [5]};
[matObj, nFileSelected] = SHH_get_matObj_A2(fileSelectionList, '../ARH_DB4_2/', true);

%%% is a cell array
test = iscell(matObj);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough cells in the cell array
nFile = length(matObj);
test  = nFile == length([fileSelectionList{:}]);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is nFileSelected correct
test  = nFileSelected == nFile;
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the good object in each cells
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
	subtest(iFile) = isa(matObj{1}, 'matlab.io.MatFile');
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is there enough filed in 
subtest = zeros(1, nFile);
for iFile = 1 : nFile,
    subtest(iFile) = length(who(matObj{iFile})) == NFIELD;
end
test = ~any(~subtest);
if test == false, error('Test failed.'); else disp('Test succedded.'); end

%%% is it the right signal
test = (matObj{1}.signal(1, 2*matObj{1}.fs) - 0.0011 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end
test = (matObj{2}.signal(1, 2*matObj{2}.fs) - 1.0761e-4 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end
test = (matObj{3}.signal(1, 2*matObj{3}.fs) - -0.0047 < 1e-8);
if test == false, error('Test failed.'); else disp('Test succedded.'); end