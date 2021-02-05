%% Define the 22 variables (namely 22 operations)
% load data (normalized data)
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL'; 
filename = ['HCTSA_ts_' subjectId '_' nightId '_' channelId '_N.mat']; 
load(fullfile(pwd, '..', filename)); 

%% 

[R, P] = corrcoef(TS_DataMat); 
imagesc(R)
colorbar % turn on the color bar 
colormap jet % use the jet color scheme


