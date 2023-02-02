function [x,fs]=getwav(name)

fid=fopen(name,'r');
x=fread(fid,'short');
fclose(fid);

fs=x(13);
if (fs<0) fs=fs+65536; end;
x=x(23:length(x));
x=x';