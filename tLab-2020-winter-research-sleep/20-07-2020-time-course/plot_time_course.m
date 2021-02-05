clear;clc;
% import FieldTrip toolbox into Matlab 
p = fullfile(userpath, 'fieldtrip-20200115'); 
% add the fieldtrip path to the current session.
% (IMPORTANTA: Don't set the "Set Path" in HOME tab, 
%              it will pollute MATLAB's Library. Run this script every time)
addpath(p);
ft_defaults

% load data
subjectId = 'S12'; 
nightId = 'night2'; 
channelId = 'EEGL.mat'; 

load(fullfile(pwd, subjectId, nightId, channelId)); 
fs = hdr.frequency;

% plot time course 
plot((1:length(record))/hdr.frequency/60/60, record)
ylabel('EEG voltage (uV)'), xlabel('time(hr)'); 

% % plot time course in the middle 
% figure 
% s = 3*60*60*hdr.frequency; 
% d = 1.5*hdr.frequency; 
% plot(s:s+d, record(s:s+d))



