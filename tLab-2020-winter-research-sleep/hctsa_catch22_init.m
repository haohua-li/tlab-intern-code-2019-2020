% add HCTSA to the matlab path 
if ispc
    run('C:\Users\massw\Documents\MATLAB\hctsa2020\startup.m');
else 
    run('/home/haohual/ot95/haohua/hctsa_bin/'); 
end 

% set the operations to computer 
subject = 'S12'; 
nightid = 'night2'; 
channelid = 'EEGL'; 
load(fullfile(pwd, subject, nightid, [channelid '.mat']))
filename = ['ts_' subject '_' nightid '_' channelid '.mat']; 

% set the duration of a segment 
d = 30; %  each epoch will be 30s long.  / sampling rate is hdr.frequency 
nSample_epoch = d*hdr.frequency ;% the number of samples in an epoch

% cut the whole record into several segements  
nSegment = floor(length(record) / nSample_epoch); % the number of segments 
new_record = record(1:nSegment*nSample_epoch); % trucation of the record 
new_record = reshape(new_record, nSample_epoch, nSegment);
new_record = new_record'; % since reshape() populate the elements from the column, we need to transform it

% specify the time series in HCTSA format 
timeSeriesData = num2cell(new_record,2); % 2 means row-major

% % For manual check
% for i = 1:10
%     figure
%     subplot(1, 2, 1)
%     plot(1:length(timeSeriesData{i}), timeSeriesData{i})
%     subplot(1, 2, 2)
%     plot(1:nSample_epoch, record(1, (i-1)*nSample_epoch+1:i*nSample_epoch)) 
% end

% specify the name of each time series 
labels = strings(nSegment, 1); 
keywords = strings(nSegment, 1); 
for i = 1:nSegment
    labels(i) = strcat('Sleep_EEG_epoch_t', num2str(i));
    keywords(i) = 'EEG,sleep'; 
end 
labels = cellstr(labels); 
keywords = cellstr(keywords);

% Save these variables out to INP_test.mat:
save(filename, 'timeSeriesData','labels','keywords', 'groupsTS_LabelGroups'); 
TS_Init(filename, 'INP_mops_catch22.txt','INP_ops_catch22.txt', [true,false,false], ['HCTSA_' filename])

% Compute all missing values in HCTSA.mat:
TS_Compute(true, [], [],  'missing', ['HCTSA_' filename]);
TS_Normalize('mixedSigmoid',[1.0,1.0], ['HCTSA_' filename]);

