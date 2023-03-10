% Relev? des harmoniques principales pour P03 (T1800)
% h{x,y} : x = erreur
%          y = identifiant mvt (en fonction de l'erreur)

% La diff?rence entre le script V1 et V2 est que la version 2 prend en
% compte des labels pour notifier quelles sont les modes ascendants et
% descendants ainsi que les modes "longs".

% 12.03.2012

clear all;
close all;
clc;

harm{1, 1} =   [68.2, 67.2, 66.2, 61.9, 56.6, 49.0, 46.5, 39.8, 34.8, 00.0, 31.2, 00.0, 26.8, 25.4, 24.2, 0.0, 1.4; ...
                68.2, 00.0, 00.0, 61.9, 56.6, 49.0, 00.0, 00.0, 34.8, 32.0, 31.2, 30.3, 26.8, 25.4, 00.0, 4.3, 1.4; ...
                68.2, 67.2, 66.2, 61.9, 56.6, 49.0, 46.5, 39.8, 34.8, 00.0, 31.2, 00.0, 26.8, 25.4, 24.2, 0.0, 1.4; ...
                68.2, 00.0, 00.0, 61.9, 56.6, 49.0, 00.0, 00.0, 34.8, 32.0, 31.2, 30.3, 26.8, 25.4, 00.0, 4.3, 1.4; ...
                68.2, 67.2, 66.2, 61.9, 56.6, 49.0, 46.5, 39.8, 34.8, 00.0, 31.2, 00.0, 26.8, 00.0, 24.2, 0.0, 1.4; ...
                68.2, 00.0, 00.0, 61.9, 56.6, 49.0, 00.0, 00.0, 34.8, 32.0, 31.2, 30.3, 26.8, 25.4, 00.0, 4.3, 1.4; ...
                68.2, 67.2, 66.2, 61.9, 56.6, 49.0, 46.5, 39.8, 34.8, 00.0, 31.2, 00.0, 26.8, 00.0, 24.2, 0.0, 1.4; ...
                68.2, 00.0, 00.0, 61.9, 56.6, 49.0, 00.0, 00.0, 34.8, 32.0, 31.2, 30.3, 26.8, 00.0, 00.0, 4.3, 1.4]';
hLegend{1, 1} =[ 'L',  ' ',  ' ',  ' ',  ' ',  ' ',  'L',  ' ',  ' ',  '+',  ' ',  '+',  'L',  'L',  'L', 'L', ' '];

harm{1, 2} =   [67.2, 61.5, 48.0, 34.6, 33.2, 00.0, 00.0, 00.0, 00.0, 26.8, 25.4, 24.6, 00.0, 00.0, 16.6, 15.6, 00.0, 4.3, 1.4; ...
                67.2, 61.5, 48.0, 34.6, 33.2, 31.6, 30.3, 28.7, 27.3, 26.8, 25.4, 24.6, 21.9, 19.5, 16.6, 15.6, 11.1, 4.3, 1.4; ...
                67.2, 61.5, 00.0, 34.6, 00.0, 00.0, 00.0, 00.0, 00.0, 26.8, 25.4, 00.0, 00.0, 00.0, 00.0, 15.6, 00.0, 4.3, 1.4; ...
                67.2, 61.5, 48.0, 34.6, 33.2, 31.6, 30.3, 28.7, 27.3, 26.8, 25.4, 24.6, 21.9, 19.5, 16.6, 15.6, 11.1, 4.3, 1.4; ...
                67.2, 61.5, 48.0, 34.6, 33.2, 00.0, 00.0, 00.0, 00.0, 26.8, 00.0, 24.6, 00.0, 00.0, 16.6, 15.6, 11.1, 4.3, 1.4; ...
                67.2, 61.5, 48.0, 34.6, 33.2, 31.6, 30.3, 28.7, 27.3, 26.8, 25.4, 24.6, 21.9, 19.5, 16.6, 15.6, 11.1, 4.3, 1.4; ...
                67.2, 61.5, 00.0, 34.6, 00.0, 00.0, 00.0, 00.0, 00.0, 26.8, 25.4, 00.0, 00.0, 00.0, 16.6, 15.6, 00.0, 4.3, 1.4; ...
                67.2, 61.5, 48.0, 34.6, 33.2, 31.6, 30.3, 28.7, 00.0, 26.8, 25.4, 24.6, 21.9, 19.5, 16.6, 15.6, 11.1, 4.3, 1.4]';
hLegend{1, 2} =[ 'L',  ' ',  ' ',  ' ',  ' ',  '+',  '+',  '+',  '+',  'L',  'L',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ', ' ', ' '];

harm{1, 3} =   [85.6, 00.0, 66.4, 64.6, 61.3, 52.9, 48.6, 38.9, 37.5, 35.2, 00.0, 00.0, 00.0, 26.6, 00.0, 00.0, 18.7, 00.0, 16.4, 14.8, 00.0, 11.1, 0.0, 0.0, 4.1, 1.4; ...
                85.6, 77.1, 66.4, 64.6, 61.3, 52.9, 00.0, 00.0, 00.0, 35.2, 28.7, 00.0, 27.7, 26.6, 21.7, 19.7, 00.0, 18.2, 16.4, 14.8, 11.7, 11.1, 9.4, 6.4, 0.0, 1.4; ...
                85.6, 77.1, 66.4, 64.6, 61.3, 52.9, 48.6, 00.0, 00.0, 35.2, 00.0, 27.9, 00.0, 26.6, 21.7, 19.7, 18.7, 18.2, 16.4, 14.8, 00.0, 11.1, 9.4, 6.4, 4.1, 1.4; ...
                00.0, 77.1, 66.4, 64.6, 61.3, 52.9, 00.0, 00.0, 00.0, 35.2, 00.0, 00.0, 27.7, 26.6, 21.7, 19.7, 00.0, 18.2, 16.4, 14.8, 11.7, 11.1, 9.4, 6.4, 4.1, 1.4; ...
                85.6, 77.1, 66.4, 64.6, 61.3, 52.9, 48.6, 38.9, 37.5, 35.2, 00.0, 00.0, 00.0, 26.6, 21.7, 19.7, 00.0, 18.2, 16.4, 14.8, 00.0, 11.1, 9.4, 6.4, 4.1, 1.4; ...
                85.6, 00.0, 66.4, 64.6, 61.3, 52.9, 48.6, 00.0, 00.0, 35.2, 28.7, 00.0, 27.7, 26.6, 00.0, 19.7, 00.0, 18.2, 16.4, 14.8, 11.7, 11.1, 9.4, 6.4, 0.0, 1.4; ...
                00.0, 77.1, 66.4, 64.6, 61.3, 52.9, 48.6, 38.9, 00.0, 35.2, 00.0, 27.9, 00.0, 26.6, 21.7, 19.7, 00.0, 18.2, 16.4, 14.8, 00.0, 11.1, 9.4, 6.4, 4.1, 1.4; ...
                85.6, 77.1, 66.4, 64.6, 61.3, 52.9, 00.0, 00.0, 00.0, 35.2, 00.0, 00.0, 00.0, 26.6, 21.7, 19.7, 00.0, 18.2, 16.4, 14.8, 11.7, 11.1, 9.4, 6.4, 0.0, 1.4]';
hLegend{1, 3} =[ ' ',  ' ',  'L',  ' ',  ' ',  ' ',  ' ',  '-',  '-',  ' ',  '+',  '-',  '+',  'L',  ' ',  ' ',  '-',  ' ',  ' ',  ' ',  ' ',  'L', 'L', 'L', ' ', ' '];


harm{2, 1} =   [65.8, 62.3, 00.0, 00.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 0.0, 7.8, 5.3, 4.3, 1.0; ...
                65.8, 62.3, 49.4, 42.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 00.0, 0.0, 0.0, 5.3, 4.3, 1.0; ...
                65.8, 62.3, 00.0, 00.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 0.0, 7.8, 5.3, 4.3, 1.0; ...
                65.8, 62.3, 49.4, 42.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 9.4, 0.0, 5.3, 4.3, 1.0; ...
                65.8, 62.3, 00.0, 00.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 9.4, 7.8, 5.3, 4.3, 1.0; ...
                65.8, 62.3, 49.4, 42.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 9.4, 0.0, 0.0, 4.3, 1.0; ...
                65.8, 62.3, 00.0, 00.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 9.4, 7.8, 5.3, 4.3, 1.0; ...
                65.8, 62.3, 49.4, 42.0, 34.8, 33.2, 31.4, 26.9, 25.0, 16.2, 13.7, 9.4, 7.8, 5.3, 4.3, 1.0]'; 
hLegend{2, 1} =[ ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'L',  'L',  ' ',  ' ', ' ', ' ', ' ', 'L', ' '];

harm{2, 2} =   [67.7, 61.3, 48.6, 34.8, 00.0, 31.6, 31.2, 00.0, 26.4, 25.2, 24.2, 21.7, 00.0, 16.0, 00.0, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 48.6, 34.8, 31.8, 00.0, 00.0, 28.9, 26.4, 25.2, 24.2, 21.7, 00.0, 16.0, 00.0, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 48.6, 34.8, 00.0, 31.6, 31.2, 00.0, 26.4, 25.2, 24.2, 21.7, 19.5, 16.0, 10.9, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 48.6, 34.8, 31.8, 00.0, 00.0, 00.0, 26.4, 25.2, 24.2, 21.7, 19.5, 16.0, 10.9, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 48.6, 34.8, 00.0, 31.6, 31.2, 00.0, 26.4, 25.2, 24.2, 21.7, 19.5, 16.0, 10.9, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 00.0, 34.8, 31.8, 00.0, 00.0, 28.9, 26.4, 25.2, 00.0, 21.7, 19.5, 16.0, 10.9, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 48.6, 34.8, 00.0, 31.6, 31.2, 00.0, 26.4, 25.2, 24.2, 21.7, 19.5, 16.0, 10.9, 9.2, 5.3, 1.4; ...
                67.7, 61.3, 48.6, 34.8, 31.8, 00.0, 00.0, 28.9, 26.4, 25.2, 24.2, 21.7, 19.5, 16.0, 10.9, 9.2, 5.3, 1.4]';
hLegend{2, 2} =[ 'L',  ' ',  ' ',  ' ',  '+',  ' ',  '-',  '+',  'L',  'L',  ' ',  ' ',  ' ',  ' ',  ' ', ' ', ' ', ' '];

harm{2, 3} =   [66.8, 61.5, 48.4, 34.8, 34.7, 00.0, 30.8, 00.0, 00.0, 26.6, 25.4, 21.3, 00.0, 16.0, 9.2, 7.6, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 00.0, 32.0, 00.0, 28.9, 26.6, 26.6, 25.4, 00.0, 19.7, 16.0, 9.2, 7.6, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 34.7, 00.0, 30.8, 00.0, 00.0, 26.6, 25.4, 21.3, 00.0, 16.0, 9.2, 7.6, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 00.0, 32.0, 00.0, 00.0, 26.6, 26.6, 00.0, 00.0, 19.7, 16.0, 9.2, 7.6, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 34.7, 00.0, 30.8, 00.0, 00.0, 26.6, 25.4, 21.3, 00.0, 00.0, 9.2, 0.0, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 00.0, 32.0, 00.0, 28.9, 26.6, 26.6, 00.0, 00.0, 19.7, 16.0, 9.2, 7.6, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 34.7, 00.0, 00.0, 00.0, 00.0, 26.6, 25.4, 21.3, 00.0, 16.0, 9.2, 7.6, 1.4; ...
                66.8, 61.5, 48.4, 34.8, 00.0, 32.0, 00.0, 28.9, 26.6, 26.6, 00.0, 00.0, 19.7, 16.0, 9.2, 7.6, 1.4]';
hLegend{2, 3} =[ 'L',  ' ',  ' ',  ' ',  '-',  '+',  '-',  '+',  '+',  'L',  'L',  ' ',  ' ',  ' ', ' ', ' ', ' '];


harm{3, 1} =   [70.3, 68.2, 61.9, 61.3, 34.8, 00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 26.8, 00.0, 24.2, 19.7, 16.2, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6; ...
                70.3, 68.2, 61.9, 61.3, 34.8, 00.0, 32.0, 00.0, 30.6, 00.0, 29.3, 00.0, 26.8, 00.0, 24.2, 19.7, 16.2, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6; ...
                70.3, 68.2, 61.9, 61.3, 00.0, 34.0, 00.0, 30.9, 00.0, 29.7, 00.0, 00.0, 26.8, 25.4, 24.2, 19.7, 16.2, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6; ...
                00.0, 68.2, 61.9, 61.3, 34.8, 00.0, 32.0, 00.0, 30.6, 00.0, 29.3, 27.3, 26.8, 25.4, 24.2, 19.7, 16.2, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6; ...
                70.3, 68.2, 61.9, 61.3, 00.0, 34.0, 00.0, 30.9, 00.0, 29.7, 00.0, 00.0, 26.8, 25.4, 24.2, 19.7, 00.0, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6; ...
                00.0, 68.2, 61.9, 61.3, 34.8, 00.0, 32.0, 00.0, 30.6, 00.0, 29.3, 27.3, 26.8, 25.4, 24.2, 19.7, 16.2, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6; ...
                00.0, 68.2, 61.9, 61.3, 00.0, 00.0, 00.0, 30.9, 00.0, 29.7, 00.0, 00.0, 26.8, 25.4, 24.2, 00.0, 00.0, 15.2, 10.9, 9.2, 7.8, 5.5, 1.6]';
hLegend{3, 1} =[ ' ',  ' ',  ' ',  ' ',  ' ',  '-',  '+',  '-',  '+',  '-',  '+',  '+',  'L',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ', 'L', ' ', ' ', ' '];

harm{3, 2} =   [66.4, 61.7, 31.8, 29.7, 26.9, 24.8, 00.0, 19.9, 16.0, 10.7, 8.8, 4.3, 1.0; ...
                66.4, 00.0, 00.0, 00.0, 26.9, 24.8, 24.2, 19.9, 16.0, 10.7, 8.8, 4.3, 1.0; ...
                66.4, 61.7, 31.8, 29.7, 26.9, 24.8, 00.0, 19.9, 16.0, 10.7, 0.0, 4.3, 1.0; ...
                66.4, 00.0, 00.0, 00.0, 26.9, 24.8, 24.2, 19.9, 16.0, 10.7, 8.8, 4.3, 1.0; ...
                66.4, 61.7, 31.8, 29.7, 26.9, 24.8, 00.0, 19.9, 16.0, 10.7, 8.8, 4.3, 1.0; ...
                66.4, 00.0, 00.0, 00.0, 26.9, 24.8, 24.2, 19.9, 16.0, 10.7, 8.8, 4.3, 1.0; ...
                66.4, 61.7, 31.8, 29.7, 26.9, 24.8, 00.0, 19.9, 16.0, 10.7, 0.0, 4.3, 1.0; ...
                66.4, 00.0, 00.0, 00.0, 26.9, 24.8, 24.2, 19.9, 16.0, 10.7, 8.8, 4.3, 1.0]';
hLegend{3, 2} =[ 'L',  ' ',  '+',  '+',  'L',  'L',  ' ',  ' ',  ' ',  ' ', ' ', ' ', ' '];

harm{3, 3} =   [66.8, 65.2, 63.3, 61.5, 48.2, 42.8, 35.0, 31.8, 30.3, 28.7, 00.0, 00.0, 26.6, 24.2, 21.7, 19.7, 15.8, 15.2, 10.9, 0.0, 7.8, 6.6, 4.5; ...
                66.8, 65.2, 63.3, 61.5, 00.0, 42.8, 35.0, 31.8, 00.0, 00.0, 28.5, 27.9, 26.6, 24.2, 21.7, 19.7, 15.8, 15.2, 10.9, 9.2, 7.8, 6.6, 4.5; ...
                66.8, 00.0, 63.3, 61.5, 48.2, 00.0, 35.0, 31.8, 30.3, 28.7, 00.0, 00.0, 26.6, 24.2, 21.7, 19.7, 15.8, 15.2, 10.9, 0.0, 7.8, 6.6, 4.5; ...
                66.8, 65.2, 00.0, 61.5, 48.2, 42.8, 35.0, 31.8, 00.0, 00.0, 28.5, 27.9, 26.6, 24.2, 21.7, 19.7, 15.8, 15.2, 00.0, 0.0, 7.8, 6.6, 4.5; ...
                66.8, 00.0, 63.3, 61.5, 48.2, 42.8, 35.0, 31.8, 30.3, 28.7, 00.0, 00.0, 26.6, 00.0, 21.7, 19.7, 15.8, 15.2, 10.9, 0.0, 7.8, 6.6, 4.5; ...
                66.8, 65.2, 00.0, 61.5, 48.2, 42.8, 35.0, 31.8, 00.0, 00.0, 28.5, 27.9, 26.6, 24.2, 21.7, 19.7, 15.8, 15.2, 10.9, 9.2, 7.8, 6.6, 4.5; ...
                66.8, 00.0, 63.3, 61.5, 00.0, 42.8, 35.0, 31.8, 30.3, 28.7, 00.0, 00.0, 26.6, 24.2, 21.7, 19.7, 15.8, 15.2, 10.9, 0.0, 7.8, 6.6, 4.5; ...
                66.8, 65.2, 00.0, 61.5, 48.2, 42.8, 35.0, 00.0, 00.0, 00.0, 28.5, 00.0, 26.6, 24.2, 00.0, 19.7, 15.8, 15.2, 00.0, 9.2, 7.8, 6.6, 4.5]';
hLegend{3, 3} =[ 'L',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  '+',  '+',  ' ',  '-',  'L',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ', ' ', ' ', ' ', ' ']; 


harm{4, 1} =   [00.0, 66.2, 00.0, 64.3, 63.9, 61.5, 48.4, 26.6, 19.5, 16.0, 0.0, 6.4, 0.0, 1.2; ...
                66.8, 00.0, 65.8, 00.0, 00.0, 00.0, 00.0, 26.6, 00.0, 16.0, 9.2, 0.0, 4.5, 0.0; ...
                00.0, 66.2, 00.0, 64.3, 63.9, 61.5, 48.4, 26.6, 19.5, 16.0, 0.0, 6.4, 0.0, 1.2; ...
                66.8, 00.0, 65.8, 00.0, 00.0, 00.0, 00.0, 26.6, 00.0, 16.0, 9.2, 0.0, 4.5, 0.0; ...
                00.0, 66.2, 00.0, 64.3, 63.9, 61.5, 48.4, 26.6, 19.5, 16.0, 0.0, 6.4, 0.0, 1.2; ...
                66.8, 00.0, 65.8, 00.0, 00.0, 00.0, 00.0, 26.6, 00.0, 16.0, 9.2, 0.0, 4.5, 0.0; ...
                00.0, 66.2, 00.0, 64.3, 63.9, 61.5, 48.4, 26.6, 19.5, 16.0, 0.0, 6.4, 0.0, 1.2; ...
                66.8, 00.0, 65.8, 00.0, 00.0, 00.0, 00.0, 26.6, 00.0, 16.0, 9.2, 0.0, 4.5, 0.0]';
hLegend{4, 1} =[ ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'L',  ' ',  ' ', ' ', ' ', ' ', ' '];

harm{4, 2} =   [68.2, 65.8, 63.9, 61.5, 51.6, 48.4, 34.8, 26.9, 16.4, 15.2, 00.0, 10.9, 1.2; ...
                00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 26.9, 00.0, 15.2, 11.3, 00.0, 1.2; ...
                68.2, 65.8, 63.9, 61.5, 51.6, 48.4, 34.8, 26.9, 16.4, 15.2, 00.0, 10.9, 1.2; ...
                00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 26.9, 00.0, 15.2, 11.3, 00.0, 1.2; ...
                68.2, 65.8, 63.9, 61.5, 51.6, 48.4, 34.8, 26.9, 16.4, 15.2, 00.0, 10.9, 1.2; ...
                00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 00.0, 26.9, 00.0, 15.2, 11.3, 00.0, 1.2; ...
                68.2, 65.8, 63.9, 61.5, 51.6, 48.4, 34.8, 26.9, 16.4, 15.2, 00.0, 10.9, 1.2]';
hLegend{4, 2} =[ ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ', ' '];

harm{4, 3} =   [00.0, 67.7, 00.0, 61.1, 00.0, 00.0, 35.0, 26.8, 25.4, 12.7, 6.0, 5.1, 1.4; ...
                67.8, 00.0, 61.3, 00.0, 54.3, 48.6, 35.0, 26.8, 25.4, 00.0, 6.0, 5.1, 1.4; ...
                00.0, 67.7, 00.0, 61.1, 00.0, 00.0, 35.0, 26.8, 25.4, 12.7, 6.0, 5.1, 1.4; ...
                67.8, 00.0, 61.3, 00.0, 54.3, 48.6, 35.0, 26.8, 25.4, 00.0, 6.0, 5.1, 1.4; ...
                00.0, 67.7, 00.0, 61.1, 00.0, 00.0, 35.0, 26.8, 25.4, 12.7, 6.0, 5.1, 1.4; ...
                67.8, 00.0, 61.3, 00.0, 54.3, 48.6, 35.0, 26.8, 25.4, 00.0, 6.0, 5.1, 1.4; ...
                00.0, 67.7, 00.0, 61.1, 00.0, 00.0, 35.0, 26.8, 25.4, 12.7, 6.0, 5.1, 1.4; ...
                67.8, 00.0, 61.3, 00.0, 54.3, 48.6, 35.0, 26.8, 25.4, 00.0, 6.0, 5.1, 1.4]';
hLegend{4, 3} =[ ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  ' ',  'L',  'L',  ' ', ' ', ' ', ' '];


figure('color', 'white');
hold on;

for errId = 1 : size(harm, 1),
    for fileId = 1 : size(harm, 2);
        for tocId = 1 : size(harm{errId, fileId}, 2),
            
            tocHarm = harm{errId, fileId}(:, tocId);
            tocLegend = hLegend{errId, fileId};
            for iHarm = 1 : size(harm{errId, fileId}, 1)
                
                if tocHarm(iHarm) > 0,
                    xId = (errId-1)*3 + fileId + 0.1*(tocId-1);
                    switch tocLegend(iHarm),
                        case ' ', colorPlot= 'b';
                                  formPlot = '.';
                        case 'L', colorPlot= 'r';
                                  formPlot = '.';
                        case '+', colorPlot= 'b';
                                  formPlot = '^';
                        case '-', colorPlot= 'b';
                                  formPlot = 'V';
                        
                    end
                    
                    plot(xId, tocHarm(iHarm), [formPlot, colorPlot]);
                end
                
                if tocId >= 5 && tocHarm(iHarm) > 0,
                    if sum(any(harm{errId, fileId} == tocHarm(iHarm))) >= 5,
                        line([(errId-1)*3 + fileId, (errId-1)*3 + fileId + 0.1*(size(harm{errId, fileId}, 2)-1)], [tocHarm(iHarm), tocHarm(iHarm)], 'color', colorPlot);
                    end
                end
                
            end
        end
    end
    
    sepLineIdx = (errId-1)*3 + fileId + 0.1*(size(harm{errId, fileId}, 2) + 2);
    line([sepLineIdx, sepLineIdx], [0, 100], 'color', 'k');
    xlim([0.9, 12.6])
end

xlabel('Class index (1-3 : ''Sans d?faut'' | 4-6 : ''Non lubrifi?'' | 7-9: ''Spiral d?centr?'' | 10-12 : ''Dents sur impulsion'')');
ylabel('Frequency [kHz]');