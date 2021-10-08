% -------------------------------------------------------
% Notch filter that removes artifacts in a signal present at a frequency of f0 Hz.
%
% Inputs:
%   signal: signal to be filtered. Matrix of nxm dimensions, n being the
%       number of samples and m the number of channels.
%   fs: sampling frequency.
%   f0: frequency (Hz) at which the artifacts occur. For instance, powerline
%       interference occurs at 50 Hz.
%   width: bandwidth (Hz) of the notch filter around f0.
%
% Outputs:
%   signal_filtered: filtered signal
% -------------------------------------------------------

function [signal_filtered]=notch_filter(signal,fs,f0,width)

% There will be peaks at k*f0 Hz in the frequency space which need to be
% removed
% Number of harmonics within the Nyquist frequency range.
K=floor(fs/2*1/f0);

% Signal length
[~,n_channels] = size(signal);

% Extend signal to prevent bordering artifacts
extra_signal_len=round(0.75*ceil(fs/width));
signal_filtered=zeros(size(signal,1)+2*extra_signal_len,size(signal,2));
for i=1:n_channels
    signal_filtered(:,i)=wextend('1D','sp0',signal(:,i),extra_signal_len);
end

L=size(signal_filtered,1); % Extended signal length
f=(0:1:L-1)/L*fs; % Frequency array

sigmaf=width; % Standard deviation of gaussian bell used to select frequency
sigma=ceil(L*sigmaf/fs); % Sigma discrete
lg=2*round(4*sigma)+1; % Size of gaussian bell
lb=(lg-1)/2; % Position of center of guassian bell
g=fspecial('gaussian',[1,lg],sigma)'; % Gaussian bell
g=1/(max(g)-min(g))*(max(g)-g); % Scale gaussian bell to be in interval [0;1]

H=ones(size(signal_filtered,1),1); % Filter

% Periodical gaussian bells at k*f0Hz
for k=1:K
        [~,b]=min(abs(f-k*f0)); % Discrete position at which f=k*f0Hz
        H(b-lb:b+lb)=g; % Gaussian bell placed around k*f0Hz
        H(L+2-b-lb:L+2-b+lb)=g; % Gaussian bell placed symmetriclly around fs-k*f0Hz   
end

H=repmat(H,1,size(signal_filtered,2)); % Reproduce the filter for all channels
X=fft(signal_filtered); % FFT of signal
Y=H.*X; % Filtering process in the Fourier Domain
signal_filtered=real(ifft(Y)); % Reconstruction of filtered signal

% Remove signal extension
signal_filtered=signal_filtered(extra_signal_len+1:end-extra_signal_len,:);
