load handel %this music dataset is built into Matlab
audiowrite('handel.wav',y,Fs)

Nw = 256;

[ywinhat,fw2,t2,P2] = spectrogram(y,hann(Nw,'periodic'),Nw/2,Nw,Fs);

% Convert 1-sided power spectral density P2 (in power per Hz)
% into two sided periodogram (in power per FFT frequency

S2 = P2*Fs/Nw;
SdB2 = 10*log10(S2); % Convert spectral power to decibel scale
mean_power = repmat(mean(SdB2,2), [1, size(SdB2,2)]); 
figure
imagesc(t2,fw2,SdB2-mean_power,'CDataMapping','scaled')  %CDataMapping=scaled
% uses the range of values of SdB2 to make the color scale.
axis xy % Puts low frequencies at the bottom
colormap('jet')
colorbar
