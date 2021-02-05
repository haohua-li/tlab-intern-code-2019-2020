%% 
%-------------------------------------------------------------------------
% K-means clustering 
%------------------------------------------------------------------------- 

% reset the random seed with a new clock (the current date and time)
rng('shuffle') 

% load data (normalized data)
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL'; 
filename = ['HCTSA_ts_' subjectId '_' nightId '_' channelId '_N.mat']; 
load(fullfile(pwd, '..', filename)); 

error('Do not destory the data......')
% kmeans parameters 
k = 5; 
% use cosine distance metric (instead of sqeuclidean)
[idx,C] = kmedoids(TS_DataMat, k, 'Distance', 'sqeuclidean');

save('sleep_whole_night_cluster_results', 'idx', 'C', 'pointsColor')
