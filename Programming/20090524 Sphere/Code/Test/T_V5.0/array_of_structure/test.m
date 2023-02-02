clear all;
close all;
clc;

a = struct('a',{},'b',{});
a = repmat(a, 1, 5);

b.tr = zeros(1, 3);
b.te = zeros(1, 4);
b = repmat(b, 1, 5);

for i = 1:5,
    
    struct.a = i+1;
    struct.b = i*2;
    
    a(i) = struct; 
    
    
end

a(1).a
