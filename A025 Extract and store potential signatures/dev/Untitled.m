% plot(timeAxis./0.99471, abs(signal));
% d = 0.2e-3*fs;
% d = 2*0.2e-3*fs;
% plot(timeAxis./0.99471, abs(running_mean(signal, d)));

% text('position',[0.03, 9], 'background', [0.95, 0.95, 0.95], 'fontsize', 14, 'interpreter','latex', 'string', '$$A(z, f) = A_0\exp\left( -\frac{fz}{c} \right)$$');

% clc;

dcm_obj = datacursormode(gcf); 
info_struct = getCursorInfo(dcm_obj); 
a = [info_struct.Position]; 
% disp(a(end-1:-2:1));
b = a(end-1:-2:1);

b1 = sort(b);

n = 13;
c = b1(repmat((1:9:(n-2)*10)', 1, 9)+repmat((0:8), n, 1))