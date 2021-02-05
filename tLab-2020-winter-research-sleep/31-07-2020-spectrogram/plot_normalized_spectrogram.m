%%
% load data (normalized data)
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL'; 
filename = ['spectrogram_' subjectId '_' nightId '_' channelId '.mat']; 
load(fullfile(pwd, filename)); 

%% 
% 'means(power, 2)' to get the mean of over all columns in each row.
%   - in this case, it can compress all frequencies to a single mean in
%   each epoch.
%   - each epoch now has a single mean. 
%   - use 'repmat' to copy this column vector by size(power, 2) 

power = spect'; 
mean_power = repmat(mean(power,1), [1, size(power,2)]); 

figure  
% plot the normalized spectrogram 
imagesc(stimes, sfreqs, (pow2db(power)-pow2db(mean_power))) 
axis xy
colormap('jet')
xlabel('Time (s)');
ylabel('Frequency (Hz)')
title('Normalized Spectrogram (by substracting mean power at each epoch)')
%caxis([-20 35])
c = colorbar;
ylabel(c,'Power (dB)');
axis tight


% catch22 clustering results 


