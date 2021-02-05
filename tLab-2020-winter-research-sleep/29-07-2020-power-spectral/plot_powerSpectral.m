% load data 
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGR.mat'; 

load(fullfile(pwd, subjectId, nightId, channelId)); 
data = record; 
fs = hdr.frequency; 

% % plot time course 
% figure
% plot((1:length(record))/hdr.frequency/60/60, record)
% ylabel('EEG voltage (uV)'), xlabel('time(hr)'); 

% plot the power spectral
DecibelsFlag = 1; 
plotFlag = 1; 
[faxis, pow] = get_PowerSpec(record, fs, DecibelsFlag ,plotFlag);
