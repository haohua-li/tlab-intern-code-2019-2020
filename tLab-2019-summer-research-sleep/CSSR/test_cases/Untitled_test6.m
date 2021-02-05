clear;clc; 
%% Use HCTSA 
x = 1:10; 
try 
    x = ST_Length(x); 
catch 
    hctsa_startup_path = fullfile('..', '..', '..', 'startup.m');
    run(hctsa_startup_path)
end
clear x hctsa_startup_file 

%% load anaethesia EEG data 
subjectId = 'H0090W'; 
anesthesia_raw_eeg_path = fullfile('..', '..', '..', '..', 'tLab-summer-intern-sleep-EEG-emachine-2019-2020', 'haohua_eM', '2-anesthesia-eeg', 'data', 'restEEG_HealthySubjects', strcat(subjectId, '.mat')); 
load(anesthesia_raw_eeg_path);
clear anesthesia_raw_eeg_path

%% specify the input time series with some information. 
ts1 = [0, 4]; % take until 4s... 
ts2 = [4, 8]; 
channel_selct = 16; 


ts1_eeg =  EEG(ts1(1)*srate+1 : ts1(2)*srate, channel_selct)'; 
ts2_eeg =  EEG(ts2(1)*srate+1 : ts2(2)*srate, channel_selct)'; 

timeSeriesData = {ts1_eeg, ts2_eeg};

labels = {strcat('EEG_ch', num2str(channel_selct), '_seg', num2str(ts1(1)), '_', num2str(ts1(2))), ...
    strcat('EEG_ch', num2str(channel_selct), '_seg', num2str(ts2(1)), '_', num2str(ts2(2)))}; 
keywords = {strcat(subjectId, ',wake,', labels{1}), strcat(subjectId, ',wake,', labels{2})};
save('INP_test.mat','timeSeriesData','labels','keywords'); 

%% Specify master operations and operations 
TS_init('INP_test.mat');
TS_compute

