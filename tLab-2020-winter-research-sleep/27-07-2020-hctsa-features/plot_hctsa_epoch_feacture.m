clear;clc; 
% add HCTSA to the matlab path 
if ispc
    run('C:\Users\massw\Documents\MATLAB\hctsa2020\startup.m');
else 
    run('/home/haohual/ot95/haohua/hctsa_bin/'); 
end 

%% set the operations to computer 
subject = 'S12'; 
nightid = 'night2'; 
channelid = 'EEGL'; 

load(fullfile(pwd, subject, nightid, [channelid '.mat']))
load(['HCTSA_ts_' subject '_' nightid '_' channelid '_N.mat']) 
%%
figure 
% plot the heatmap( scaled colors)
imagesc(TS_DataMat') 
colorbar % turn on the color bar 
colormap jet % use the jet color scheme

% title of the graph 
title('Feactures vs Epochs') 

% ytick and ylabel for operations 
yticks(1:22);
ylabel('Features(catch22)') 

% infer how many samples in a epoch 
duration_per_epoch = TimeSeries.Length(1) / hdr.frequency; 
hour_tick = 3600 / duration_per_epoch;  % there are 3600 seconds in an hour. 
custom_xtick = 1:hour_tick:size(TS_DataMat, 1); 
xticks(custom_xtick);
xticklabels(cellstr(string(0:length(custom_xtick)-1)))
% cellstr : convert to cell array of character vectors 
xlabel('Time(hr)')


