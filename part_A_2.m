%% Part A - 2
close all
clear
clc

%% Identifying salt bridges

% Loading data from .txt file
data = dlmread('partIII_Group10.txt');

electrode_names = {'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};

% Setting sample rate and creating time vector
fs = 128; % Hz
len = length(data); % Samples
T = len/fs; % Sec

% Calculating vectors of difference between electrodes
P = cell(14,14);
for i = 1:14
    for j = 1:14
        
        P{i,j} =  data(:,i)-data(:,j);
        
    end
end
        
% Computing variance of the difference vectors
ED_bridges = cell(14,14);
ED = zeros(14,14);

for i = 1:14
    for j = 1:14
        
        ED_bridges{i,j} =  [electrode_names{i} ' - ' electrode_names{j}];
        ED(i,j) =  sum(((P{i,j}-mean(P{i,j})).^2)/len);
        
    end
end

% Setting variance threshold and reseting variances above the threshold
threshold = 500;

 ED(ED > threshold) = 0;

 % Printing suspected salt bridges
 fprintf('Printing suspected salt bridges - variance below %d \n\n',threshold)
 
for i = 1:14
    for j = 1:14
        
        if ED(i,j) > 0 && j>i
            
            fprintf([ED_bridges{i,j}, ' : ' , num2str(ED(i,j)), '\n'])
        
        end
    end
end
