% -------------------------------------------------------
% Filter that can be high pass or low pass.
%
% Inputs:
%   signal: signal to be filtered. Matrix of nxm dimensions, n being the
%       number of samples and m the number of channels.
%   fs: sampling frequency.
%   fc: cutoff frequency (Hz) of the filter.
%   ftype: bandwidth (Hz) of the notch filter around f0.
%
% Outputs:
%   signal_filtered: indicate whether it is a low or a high pass filter ('low'|'high')
% -------------------------------------------------------

function [signal_filtered]=filter_signal(signal,fs,fc,ftype)

% Number of channels
[~,n_channels] = size(signal);

% Extend signal to prevent bordering artifacts
extra_signal_len=round(fs*15);
signal_filtered=[zeros(extra_signal_len,n_channels);signal;zeros(extra_signal_len,n_channels)];
for i=1:n_channels
    extension=wextend(1,'sp0',signal(:,i),extra_signal_len,'r');
    signal_filtered(:,i)=wextend(1,'sp0',extension,extra_signal_len,'l');
end


if fc>fs/2
    disp('Warning: Lowpass frequency above Nyquist frequency. Nyquist frequency is chosen instead.')
    fc=floor(fs/2-1);
end

% Butterworth filter
order=3;
[z,p,k]=butter(order,2*fc/fs,ftype);
sos=zp2sos(z,p,k);
Bs = sos(:,1:3); % Second Order Section (SOS) numerator coeffitiens
As = sos(:,4:6); % Second Order Section (SOS) denominator coeffitiens
for j=1:n_channels
    for i=1:size(Bs,1)
        signal_filtered(:,j) = filtfilt(Bs(i,:),As(i,:),signal_filtered(:,j)); % recursive filtering using SOS
    end
end

% Remove signal extension
signal_filtered=signal_filtered(extra_signal_len+1:end-extra_signal_len,:);

%Constant offset removal
%signal_filtered=Isoline_Correction(signal_filtered);

