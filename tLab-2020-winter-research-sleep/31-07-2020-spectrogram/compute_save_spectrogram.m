%% The multitaper spectrogram from Prerau Lab 
% Code     - http://prerau.bwh.harvard.edu/resources/
% Tutorial - //www.youtube.com/watch?v=jjEjkXLLDJU

%% Start to plot the spectrogram 
% load the sleep data 
subject = 'S12'; 
nightid = 'night2'; 
channelid = 'EEGL'; 
load(fullfile(pwd, '..', subject, nightid, [channelid '.mat']))

%% use the multi-tapper code 
% there are two assumptions (two parameters need to tune) : 
%   1) the length of an epoch (tranditionally sleep scoring requires 30 s)
%   2) frequency resolution 

N = 30; %the windows size is 30 second 
dF = 1; % frequency resolution 1 Hz
tw = N*dF/2; 
L  = floor(2*tw)-1; 

data = record; 
fs = 256; %Sampling Frequency
frequency_range = [0 , 30]; %Limit frequencies from .5 to 50 Hz
taper_params =    [tw, L]; %Time bandwidth and number of tapers
window_params =   [N , round(N/5)]; %Window size is 4s with step size of 1s

% Plot spectrogram 
% f = figure('visible','off');  % disable the figure for MASSIVE 
% Compute the multitaper spectrogram
[spect,stimes,sfreqs] = multitaper_spectrogram(data, fs, frequency_range, ... 
                                               taper_params, window_params);
% Add title 
title(['Subject ' subject ' ' nightid ' Channel:' channelid ' Spectrogram'])
% Save the spectrogram file 
% saveas(gcf,'Barchart.png')



      