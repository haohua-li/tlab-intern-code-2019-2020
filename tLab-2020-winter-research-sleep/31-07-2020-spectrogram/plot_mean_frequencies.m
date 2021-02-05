%%
% load data (normalized data)
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL'; 
filename = ['spectrogram_' subjectId '_' nightId '_' channelId '.mat']; 
load(fullfile(pwd, filename)); 

power = spect; 
mean_power = repmat(mean(power,2), [1 size(power,2)]); 

figure  
imagesc(stimes, sfreqs, pow2db(mean_power)') 
axis xy
colormap('hot')
xlabel('Time (s)');
title('Mean Power at each epoch')
% caxis([-20 35])

c = colorbar;
ylabel(c,'Power (dB)');
axis tight
