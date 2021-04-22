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

% Taking only the elctrodes that are yellow or green (less noise)
electrodes = {AF3,F3,FC5,P7,O1,O2,T8,FC6,F4,F8};
electrode_names = {'AF3','F3','FC5','P7','O1','O2','T8','FC6','F4','F8'};

% Setting sample frequency and time vector
fs = 128; 
Ts = 1/fs;
Tmax = (length(data)-1)*Ts;

t = (0:Ts:Tmax)';


% Filtering signal with BPF (1-30 HZ)
filtered_electrodes = cell(1,length(electrodes));

BPF = fir1(1000,[0.5/64,30/64],'bandpass');

for i = 1:length(electrodes)
    
    filtered_electrodes{i} = filtfilt(BPF,1,electrodes{i});
    
end

%% Plotting signals recorded from the electrodes - original signal and filtered signal
for i = 1:length(electrodes)

    figure;

    % Plotting original signal - time domain
    subplot(2,2,1)
    plot(t,electrodes{i})
    title('Original signal - time domain')
    xlabel('Time [sec]')
    ylabel('Voltage [\muV]')


    % Computing and plotting power spectral density (PSD) estimation of original signal

    subplot(2,2,3)
    pwelch(electrodes{i},[],[],[],fs);
    title('Original signal - frequency domain')


    % Plotting filtered signal - time domain
    subplot(2,2,2)
    plot(t,filtered_electrodes{i})
    title('filtered signal - time domain')
    xlabel('Time [sec]')
    ylabel('Voltage [\muV]')
    
    % Computing and plotting power spectral density (PSD) estimation of filtered signal

    subplot(2,2,4)
    pwelch(filtered_electrodes{i},[],[],[],fs);
    title('filtered signal - frequency domain')

    suptitle(['EEG signal before and after filtering - electrode ',electrode_names{i}])
end
%% Filtering signals to contain only the frequencies of each brain wave

% The filtered signals will be used to determine which electrode we will use
% to examine each one of the waves

% Creating brain wave filters
alpha_filter = fir1(1000,[7 12]/64);
beta_filter = fir1(1000,[12 30]/64);
delta_filter = fir1(1000,[0.5 4]/64);
theta_filter = fir1(1000,[4 7]/64);

% Preallocating cells for the signals
electrodes_alpha = cell(1,length(electrodes));
electrodes_beta = cell(1,length(electrodes));
electrodes_delta = cell(1,length(electrodes));
electrodes_theta = cell(1,length(electrodes));

% Filtering the signals
for i = 1:length(electrodes)
    
    electrodes_alpha{i} = filtfilt(alpha_filter,1,filtered_electrodes{i});
    electrodes_beta{i} = filtfilt(beta_filter,1,filtered_electrodes{i});
    electrodes_delta{i} = filtfilt(delta_filter,1,filtered_electrodes{i});
    electrodes_theta{i} = filtfilt(theta_filter,1,filtered_electrodes{i});
    
end

% Creating plots showing the filtered signals in time domain and in
% frequency domain

% Alpha waves
figure;
for i = (1:10)
    
    subplot(2,5,i)
    
    plot(t(1:round(15*fs)),electrodes_alpha{i}(1:round(15*fs)));
    title(electrode_names{i}) 
    xlabel('Time [t]')
    ylabel('Voltage [\muV]')
end
suptitle('Time domain - alpha frequencies')

figure;
for i = (1:10)
    
    subplot(2,5,i)
    
    pwelch(electrodes_alpha{i}(1:round(15*fs)),[],[],[],fs);
    title(electrode_names{i})
end
suptitle('PSD - alpha frequencies')

% Beta waves
figure;
for i = (1:10)
    
    subplot(2,5,i)
    
    plot(t(1:round(15*fs)),electrodes_beta{i}(1:round(15*fs)));
    title(electrode_names{i}) 
    xlabel('Time [t]')
    ylabel('Voltage [\muV]')
end
suptitle('Time domain - beta frequencies')

figure;
for i = (1:10)
    
    subplot(2,5,i)
    
    pwelch(electrodes_beta{i}(1:round(15*fs)),[],[],[],fs);
    title(electrode_names{i})
end
suptitle('PSD - beta frequencies')

% Delta waves

figure;
for i = (1:10)
    
    subplot(2,5,i)
    
    plot(t(1:round(15*fs)),electrodes_delta{i}(1:round(15*fs)));
    title(electrode_names{i}) 
    xlabel('Time [t]')
    ylabel('Voltage [\muV]')
end
suptitle('Time domain - delta frequencies')


figure;

for i = (1:10)
    
    subplot(2,5,i)
    
    pwelch(electrodes_delta{i}(1:round(15*fs)),[],[],[],fs);
    title(electrode_names{i})
end
suptitle('PSD - delta frequencies')

% Theta waves

figure;
for i = (1:10)
    
    subplot(2,5,i)
    
    plot(t(1:round(15*fs)),electrodes_theta{i}(1:round(15*fs)));
    title(electrode_names{i}) 
    xlabel('Time [t]')
    ylabel('Voltage [\muV]')
end
suptitle('Time domain - theta frequencies')

figure;

for i = (1:10)
    
    subplot(2,5,i)
    
    pwelch(electrodes_theta{i}(1:round(15*fs)),[],[],[],fs);
    title(electrode_names{i})
end
suptitle('PSD - theta frequencies')


%% 3 

alpha = filter(alpha_filter,1,filtered_electrodes{6}); % O2 electrode
beta = filter(beta_filter,1,filtered_electrodes{5}); % O1 electrode
delta = filter(delta_filter,1,filtered_electrodes{8}); % FC6 electrode
theta = filter(theta_filter,1,filtered_electrodes{2}); % F3 electrode

seg1 = (1:round(30*fs)); % Segment 1 samples

% Computing STD of each wave in segment 1
alpha_std_1 = std(alpha(seg1));
beta_std_1 = std(beta(seg1));
delta_std_1 = std(delta(seg1));
theta_std_1 = std(theta(seg1));

% Plotting the the different waves in time domain - segment 1
figure;

subplot(2,2,1)    
plot(t(seg1),alpha(seg1))
title('Alpha wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')
    
subplot(2,2,2)    
plot(t(seg1),beta(seg1))
title('Beta wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')

subplot(2,2,3)    
plot(t(seg1),delta(seg1))
title('Delta wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')

subplot(2,2,4)    
plot(t(seg1),theta(seg1))
title('Theta wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')

suptitle({'The different waves in time domain';'segment 1 - open eyes'})


% Plotting the the different waves in frequency domain - segment 1
figure;
subplot(2,2,1)    
pwelch(alpha(seg1),[],[],[],fs);
title('Alpha wave')
    
subplot(2,2,2)    
pwelch(beta(seg1),[],[],[],fs);
title('Beta wave')

subplot(2,2,3)    
pwelch(delta(seg1),[],[],[],fs);
title('Delta wave')


subplot(2,2,4)    
pwelch(theta(seg1),[],[],[],fs);
title('Theta wave')


suptitle({'The different waves in frequency domain';'segment 1 - open eyes'})

% Segment 2 - closed eyes

seg2 = (round(30*fs):round(60*fs)); % Segment 2 samples

% Computing STD of each wave in segment 2
alpha_std_2 = std(alpha(seg2));
beta_std_2 = std(beta(seg2));
delta_std_2 = std(delta(seg2));
theta_std_2 = std(theta(seg2));

% Plotting the the different waves in time domain - segment 1
figure;

subplot(2,2,1)    
plot(t(seg2),alpha(seg2))
title('Alpha wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')
    
subplot(2,2,2)    
plot(t(seg2),beta(seg2))
title('Beta wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')

subplot(2,2,3)    
plot(t(seg2),delta(seg2))
title('Delta wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')

subplot(2,2,4)    
plot(t(seg2),theta(seg2))
title('Theta wave')
xlabel('Time [sec]')
ylabel('Voltage [\muV]')

suptitle({'The different waves in time domain';'segment 2 - closed eyes'})


% Plotting the the different waves in frequency domain - segment 1
figure;
subplot(2,2,1)    
pwelch(alpha(seg2),[],[],[],fs);
title('Alpha wave')
    
subplot(2,2,2)    
pwelch(beta(seg2),[],[],[],fs);
title('Beta wave')

subplot(2,2,3)    
pwelch(delta(seg2),[],[],[],fs);
title('Delta wave')     

subplot(2,2,4)    
pwelch(theta(seg2),[],[],[],fs);
title('Theta wave')

suptitle({'The different waves in frequency domain';'segment 2 - closed eyes'})


%% Part 2

% Loading data from .txt file
data = dlmread('partIII_Group10.txt');

fs = 128; % Hz
len = length(data_2); % Samples
T = len/fs; % Sec

P = cell(14,14);

for i = 1:14
    for j = 1:14
        
        P{i,j} =  data(i)-data(j);
        
    end
end
        

