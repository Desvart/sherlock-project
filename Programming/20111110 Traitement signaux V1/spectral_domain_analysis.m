
N = 1024;
win = blackman(N, 'periodic');
[stdft, stdftTAxis, stdftFAxis] = stdft_(signal, win, 1/16, fs);