%% EEG LAB - matlab code
clear
clc

%% Part 1
% Loading data and dividing it to relevant vectors
data = csvread('Part-A-25.03.20.08.59.27.csv');

AF3 = data(:,1);
F7 = data(:,2);
F3 = data(:,3);
FC5 = data(:,4);
T7 = data(:,5);
P7 = data(:,6);
O1 = data(:,7);
O2 = data(:,8);
P8 = data(:,9);
T8 = data(:,10);
FC6 = data(:,11);
F4 = data(:,12);
F8 = data(:,13);
Af4 = data(:,14);


%

fs = 128; % ???

Ts = 1/fs;

Tmax = (length(data)-1)*Ts;

pwe = pwelch(T8);

plot(pwe)

