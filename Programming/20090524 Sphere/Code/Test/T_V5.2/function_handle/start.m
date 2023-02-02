function start

close all; clear all; clc;
f_ = @a_;

g_ = str2func([func2str(f_), 'b']);

f_(5,4)
g_(5,4)

end

function o = a_(i1, i2)
    o = i1 + i2;
end

function o = a_b(i1, i2)
    o = i1 * i2;
end