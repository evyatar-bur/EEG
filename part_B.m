%% Part B - feeling classification

clc
clear

% Loading IC's
load('subject_ICs sampling rate 100 Hz.mat');

% Setting sample rate and time gap
fs = 100; %[Hz]
time_gap = 10; %[sec]

% Converting to array and putting all data in one cell
data_cell = cell(10,3);
    
data_cell{1,1} = table2array(subject1(:,1));
data_cell{1,2} = table2array(subject1(:,2));
data_cell{1,3} = table2array(subject1(:,3));

data_cell{2,1} = table2array(subject2(:,1));
data_cell{2,2} = table2array(subject2(:,2));
data_cell{2,3} = table2array(subject2(:,3));

data_cell{3,1} = table2array(subject3(:,1));
data_cell{3,2} = table2array(subject3(:,2));
data_cell{3,3} = table2array(subject3(:,3));

data_cell{4,1} = table2array(subject4(:,1));
data_cell{4,2} = table2array(subject4(:,2));
data_cell{4,3} = table2array(subject4(:,3));

data_cell{5,1} = table2array(subject5(:,1));
data_cell{5,2} = table2array(subject5(:,2));
data_cell{5,3} = table2array(subject5(:,3));

data_cell{6,1} = table2array(subject6(:,1));
data_cell{6,2} = table2array(subject6(:,2));
data_cell{6,3} = table2array(subject6(:,3));

data_cell{7,1} = table2array(subject7(:,1));
data_cell{7,2} = table2array(subject7(:,2));
data_cell{7,3} = table2array(subject7(:,3));

data_cell{8,1} = table2array(subject8(:,1));
data_cell{8,2} = table2array(subject8(:,2));
data_cell{8,3} = table2array(subject8(:,3));

data_cell{9,1} = table2array(subject9(:,1));
data_cell{9,2} = table2array(subject9(:,2));
data_cell{9,3} = table2array(subject9(:,3));

data_cell{10,1} = table2array(subject10(:,1));
data_cell{10,2} = table2array(subject10(:,2));
data_cell{10,3} = table2array(subject10(:,3));

% Assigning event times
anger_event = [1567.53,1729.3,1511.9,3560.84,3921.42,3535.32,1103.04,3186.75,2402.44,4100.87]; % Sec
happy_event = [1816.01,2014.59,1771.17,774.5,3613.7,2039.23,1301.27,3031.60,5445.64,1157.38]; % Sec

% Allocating IC cells for the angry and happy segments
IC1_anger = cell(10,1);
IC2_anger = cell(10,1);
IC1_happy = cell(10,1);
IC2_happy = cell(10,1);

% Deviding the ic vectors to happy and angry segments
for i = 1:10 
    
    anger_margins = [anger_event(i),anger_event(i) + time_gap]*1000; % mili-Sec 
    happy_margins = [happy_event(i),happy_event(i) + time_gap]*1000; % mili-Sec 
   
    IC1_anger{i} = data_cell{i,2}((data_cell{i,1}>anger_margins(1))&((data_cell{i,1}<anger_margins(2))));
    IC2_anger{i} = data_cell{i,3}((data_cell{i,1}>anger_margins(1))&((data_cell{i,1}<anger_margins(2))));
    IC1_happy{i} = data_cell{i,2}((data_cell{i,1}>happy_margins(1))&((data_cell{i,1}<happy_margins(2))));
    IC2_happy{i} = data_cell{i,3}((data_cell{i,1}>happy_margins(1))&((data_cell{i,1}<happy_margins(2))));
    
end

% Creating brain wave filters
alpha_filter = fir1(1000,[7 12]/(fs/2));
beta_filter = fir1(1000,[12 30]/(fs/2));

% Preallocating cell for the filtered signals
% Cell dimension : [subject(1-10),IC(1-2),wave(alpha/beta),label(angry/happy)]
IC_cell = cell(10,2,2,2);

% Filtering the signals
for i = 1:10

    IC_cell{i,1,1,1} = filter(alpha_filter,1,IC1_anger{i});
    IC_cell{i,2,1,1} = filter(alpha_filter,1,IC2_anger{i});
    IC_cell{i,1,1,2} = filter(alpha_filter,1,IC1_happy{i});
    IC_cell{i,2,1,2} = filter(alpha_filter,1,IC2_happy{i});
    
    IC_cell{i,1,2,1} = filter(beta_filter,1,IC1_anger{i});
    IC_cell{i,2,2,1} = filter(beta_filter,1,IC2_anger{i});
    IC_cell{i,1,2,2} = filter(beta_filter,1,IC1_happy{i});
    IC_cell{i,2,2,2} = filter(beta_filter,1,IC2_happy{i});
    
end

STD_Cell = cell(20,5);

% calculating STD and labeling

for i = 1:10
    for label = 1:2
    
        if label == 1
            label_string = 'anger';
                    
            STD_Cell{i,1} = std(IC_cell{i,1,1,1});
            STD_Cell{i,2} = std(IC_cell{i,2,1,1});
            STD_Cell{i,3} = std(IC_cell{i,1,2,1});
            STD_Cell{i,4} = std(IC_cell{i,2,2,1});
            STD_Cell{i,5} = label_string;
        else
            label_string = 'happy';
            
            STD_Cell{i+10,1} = std(IC_cell{i,1,1,2});
            STD_Cell{i+10,2} = std(IC_cell{i,2,1,2});
            STD_Cell{i+10,3} = std(IC_cell{i,1,2,2});
            STD_Cell{i+10,4} = std(IC_cell{i,2,2,2});
            STD_Cell{i+10,5} = label_string;
        end
    end
end
                

% Converting cell to table

header = {'Var1','Var2','Var3','Var4','class'};
STD_Table = cell2table(STD_Cell,'VariableNames',header);

% Writing the table to a CSV file
writetable(STD_Table,'weka_file.csv')
                
