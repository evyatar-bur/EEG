%% EEG LAB - matlab code
close all
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
AF4 = data(:,14);

fs = 128; 
Ts = 1/fs;
Tmax = (length(data)-1)*Ts;

electrodes = {AF3,F3,FC5,P7,O1,O2,P8,T8,FC6,F4,F8,AF4};

filtered_electrodes = cell(1,length(electrodes));

BPF = fir1(1000,, );

for i = 1:length(electrodes{1})
    
    filtered_electrodes{1} = filtfilt(BPF,1,electrodes{1});
    
end

%% Plotting one of the electrodes
figure(1)
subplot(2,2,1)
plot(electrodes{1})

[pwe,f] = pwelch(electrodes{1},500,300,500,fs);

subplot(2,2,3)
plot(f,pwe)


subplot(2,2,2)
plot(filtered_electrodes{1})

[pwe_f,f_f] = pwelch(filtered_electrodes{1},500,300,500,fs);

subplot(2,2,4)
plot(f_f,pwe_f)


