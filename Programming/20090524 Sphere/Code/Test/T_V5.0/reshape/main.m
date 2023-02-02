clc;

a = [[1;2;3],[4;5;6],[7;8;9]];
dim=3;

tic;
a3 = [];
for i = 1:dim,
    a3 = [a3; a(:,i)];
end
toc


tic;
b = reshape(a, numel(a),1);
toc

tic;
b1 = reshape(a, dim^2, 1);
toc



tic;
a2 = zeros(dim^2,1);
stop = 0;
for i = 1:dim,
    start = stop + 1;
    stop = start + dim - 1;
    a2(start:stop) = a(:,i);
end
toc