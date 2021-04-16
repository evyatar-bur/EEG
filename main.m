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

t = (0:Ts:Tmax)';

electrodes = {AF3,F3,FC5,P7,O1,O2,T8,FC6,F4,F8};

electrode_names = {'AF3','F3','FC5','P7','O1','O2','T8','FC6','F4','F8'};

filtered_electrodes = cell(1,length(electrodes));

BPF = fir1(1000,[1/64,30/64]);

for i = 1:length(electrodes)
    
    filtered_electrodes{i} = filter(BPF,1,electrodes{i});
    
end

%% Plotting one of the electrodes
figure(1)
subplot(2,2,1)
plot(t,electrodes{1})

[pwe,f] = pwelch(electrodes{1},500,300,500,fs);

subplot(2,2,3)
plot(f,pwe)


subplot(2,2,2)
plot(t,filtered_electrodes{1})

[pwe_f,f_f] = pwelch(filtered_electrodes{1},500,300,500,fs);

subplot(2,2,4)
plot(f_f,pwe_f)


%%

alpha_filter = fir1(1000,[7 12]/64);
beta_filter = fir1(1000,[12 30]/64);
delta_filter = fir1(1000,[0.5 4]/64);
theta_filter = fir1(1000,[4 7]/64);

electrodes_alpha = cell(1,length(electrodes));
electrodes_beta = cell(1,length(electrodes));
electrodes_delta = cell(1,length(electrodes));
electrodes_theta = cell(1,length(electrodes));

for i = 1:length(electrodes)
    
    electrodes_alpha{i} = filter(alpha_filter,1,filtered_electrodes{i}(1:round(15*fs)));
    electrodes_beta{i} = filter(beta_filter,1,filtered_electrodes{i}(1:round(15*fs)));
    electrodes_delta{i} = filter(delta_filter,1,filtered_electrodes{i}(1:round(15*fs)));
    electrodes_theta{i} = filter(theta_filter,1,filtered_electrodes{i}(1:round(15*fs)));
    
end

figure(2)

for i = (1:10)
    
    subplot(2,5,i)
    
    [pwe,f] = pwelch(electrodes_alpha{i},500,300,500,fs);
    
    plot(f,pwe)
    title(['alpha - ' electrode_names{i}]) %O1
end


figure(3)

for i = (1:10)
    
    subplot(2,5,i)
    
    [pwe,f] = pwelch(electrodes_beta{i},500,300,500,fs);
    
    plot(f,pwe)
    title(electrode_names{i})%FC6
end

figure(4)

for i = (1:10)
    
    subplot(2,5,i)
    
    [pwe,f] = pwelch(electrodes_delta{i},500,300,500,fs);
    
    plot(f,pwe)
    title(electrode_names{i})%FC6
end

figure(5)

for i = (1:10)
    
    subplot(2,5,i)
    
    [pwe,f] = pwelch(electrodes_theta{i},500,300,500,fs);
    
    plot(f,pwe)
    title(electrode_names{i}) %FC6
end



%% 3 

alpha = filter(alpha_filter,1,filtered_electrodes{5});
beta = filter(beta_filter,1,filtered_electrodes{8});
delta = filter(delta_filter,1,filtered_electrodes{8});
theta = filter(theta_filter,1,filtered_electrodes{8});

% Plotting segment 1 - open eyes
figure()
  
seg1 = (1:round(15*fs)); % Segment 1 samples

subplot(4,1,1)    
plot(t(seg1),alpha(seg1))
    
subplot(4,1,2)    
plot(t(seg1),beta(seg1))

subplot(4,1,3)    
plot(t(seg1),delta(seg1))

subplot(4,1,4)    
plot(t(seg1),theta(seg1))

alpha_std_1 = std(alpha(seg1));
beta_std_1 = std(beta(seg1));
delta_std_1 = std(delta(seg1));
theta_std_1 = std(theta(seg1));


% Plotting segment 2 - closed eyes
figure()
  
seg2 = (round(15*fs):round(30*fs)); % Segment 1 samples

subplot(4,1,1)    
plot(t(round(15*fs):round(30*fs)),alpha(round(15*fs):round(30*fs)))
    
subplot(4,1,2)    
plot(t(round(15*fs):round(30*fs)),beta(round(15*fs):round(30*fs)))

subplot(4,1,3)    
plot(t(round(15*fs):round(30*fs)),delta(round(15*fs):round(30*fs)))

subplot(4,1,4)    
plot(t(round(15*fs):round(30*fs)),theta(round(15*fs):round(30*fs)))

alpha_std_2 = std(alpha(seg2));
beta_std_2 = std(beta(seg2));
delta_std_2 = std(delta(seg2));
theta_std_2 = std(theta(seg2));

% Plotting segment 3 - open eyes again
figure()
  
seg3 = (round(30*fs):round(45*fs));

subplot(4,1,1)    
plot(t(round(30*fs):round(45*fs)),alpha(round(30*fs):round(45*fs)))
    
subplot(4,1,2)    
plot(t(round(30*fs):round(45*fs)),beta(round(30*fs):round(45*fs)))

subplot(4,1,3)    
plot(t(round(30*fs):round(45*fs)),delta(round(30*fs):round(45*fs)))

subplot(4,1,4)    
plot(t(round(30*fs):round(45*fs)),theta(round(30*fs):round(45*fs)))


alpha_std_3 = std(alpha(seg3));
beta_std_3 = std(beta(seg3));
delta_std_3 = std(delta(seg3));
theta_std_3 = std(theta(seg3));

%%