clear all;
close all;
clc;

load ad.mat
load ad2.mat

sum(sum(signalMatrix == xblocks))/(2048*nBlocks)
