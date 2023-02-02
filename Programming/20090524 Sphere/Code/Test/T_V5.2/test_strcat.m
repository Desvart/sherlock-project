clear all;
clc;

f = cell2mat({'f0'; 'f1'});
p = './fold/';

p = p(ones(2, 1), :);

c = [p, f]


f1 = {'f0'; 'f1'};
p1 = {'./fold/'};

p = p(ones(2, 1), :);

c = strcat(p, f)