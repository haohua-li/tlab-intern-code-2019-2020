%% 
% load data (normalized data)
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL'; 
filename = ['HCTSA_ts_' subjectId '_' nightId '_' channelId '_N.mat']; 
load(fullfile(pwd, '..', filename)); 
load('sleep_whole_night_cluster_results_S12_night2_EEGL_N.mat')

%% 
%-------------------------------------------------------------------------
% It is a good behaviours to save all computed results for data analysis 
%------------------------------------------------------------------------- 
% divide the sleep process into three main periods 
s_dur = [100, 200];               % sleep onset duration  
m_dur = [400, 500];             % the midnight ? 
w_dur = [700, 800];             % near wake (dawn)
% dive the whole TS_DataMat into three individual groups, and then apply 
%   PCA to each individual groups. 
sleep_onset_data = TS_DataMat(s_dur(1):s_dur(2), :); 
sleep_onset_cluster_label = idx(s_dur(1):s_dur(2), :); 
sleep_onset_cluster_color = pointsColor(s_dur(1):s_dur(2), :);

middle_sleep_data = TS_DataMat(m_dur(1):m_dur(2), :); 
middle_sleep_cluster_label = idx(m_dur(1):m_dur(2), :); 
middle_sleep_cluster_color = pointsColor(m_dur(1):m_dur(2), :);

near_wake_data = TS_DataMat(w_dur(1):w_dur(2), :); 
near_wake_cluster_label = idx(w_dur(1):w_dur(2), :); 
near_wake_cluster_color = pointsColor(w_dur(1):w_dur(2), :);

fname_prefix = 'sleep_period_'; 
fname_suffix = [subjectId '_' nightId '_' channelId '_N.mat']; 
save([fname_prefix 'sleep_oneset_' fname_suffix], 'sleep_onset_data', 'sleep_onset_cluster_label', 'sleep_onset_cluster_color') 
save([fname_prefix 'middle_sleep_' fname_suffix], 'middle_sleep_data', 'middle_sleep_cluster_label', 'middle_sleep_cluster_color') 
save([fname_prefix 'near_wake_' fname_suffix], 'near_wake_data', 'near_wake_cluster_label', 'near_wake_cluster_color')

