% -------------------------------------------------------
%
% Main script for ECG signal preprocessing
% 
% - Detect if there are not connected channels
% - Delete recording spikes
% - Low pass filter
%       Optional step. It is used to visualize the original vs. low pass
%       filtered signals.
% - Notch filter to remove powerline interference
%       Optional step. It is used to visualize the original vs. signal with
%       powerline interference removed
% - High pass filter
%       Optional step. It is used to visualize the original vs. high pass
%       filtered signals. This step removes baseline wander and DC offset.
% - Full preprocessing (low pass + notch + high pass filters)
%
% -------------------------------------------------------

clear all;

%% Load data

load ecgConditioningExample.mat
ecg_ = ecg; % make a copy of the data
[signal_len,channels] = size(ecg_); % retrieve sample length and number of channels
time = (1:signal_len)./fs; % create a time vector


%% Detect if there are not connected channels

not_connected = all(ecg,1); % Detect channels with zero and non-zero signal
not_connected_channels = find(~not_connected); % Channels with zero signal
if ~isempty(not_connected_channels)
    fprintf('Not connected channels: ')
    fprintf('%g ',unique(not_connected_channels))
else
    fprintf('All channels are connected')
end
fprintf('\n')


%% Delete recording spikes

channels_with_spikes=[];
for i = 1:channels
    signal_average = mean(ecg(:,i));
    % If there is a recording spike (data sample greater than 10 times average signal) 
    % set data sample equal to the previous one
    for j = 1:signal_len
        if ecg(j,i) > signal_average*10 
            channels_with_spikes = [channels_with_spikes, i]; % Store the channels with spikes
            ecg_(j,i) = ecg_(j-1,i);
        end
    end
end
fprintf('Channels with removed recording spikes: ')
fprintf('%g ',unique(channels_with_spikes))
fprintf('\n')


%% Low pass filter
% Uncomment to see low pass filtered data

LP_filtered_signal = filter_signal(ecg_,fs,150,'low');
plot_filtered_signal(time,ecg_,LP_filtered_signal,'Low pass filtered')


%% Notch filter to remove powerline interference
% Uncomment to see signal with removed powerline interference

notch_filtered_signal=notch_filter(ecg_,fs,50,1);
plot_filtered_signal(time,ecg_,notch_filtered_signal,'Powerline interference filtered')


%% High pass filter to remove baseline wander and offset
% Uncomment to see signal with removed powerline interference

HP_filtered_signal = filter_signal(ecg_,fs,0.667,'high');
plot_filtered_signal(time,ecg_,HP_filtered_signal,'High pass filtered')


%% Full preprocessing (low pass + notch + high pass filters)
% Uncomment to see signal fully preprocessed

filtered_signal = filter_signal(ecg_,fs,150,'low');
filtered_signal=notch_filter(filtered_signal,fs,50,1);
filtered_signal = filter_signal(filtered_signal,fs,0.667,'high');
plot_filtered_signal(time,ecg_,filtered_signal,'Preprocessed')

% Plot filtered signal of individual channels and check whether DC offset has been removed
for i = 1:channels
    if ~ismember(i,not_connected_channels) % Ignore disconnected channel

        % Check if DC offset has been removed
        mean_filtered_signal = mean(filtered_signal(:,i));
        mean_signal = mean(ecg_(:,i));
        fprintf('Channel %d mean filtered signal: %d. ', i, mean_filtered_signal)
        if mean_filtered_signal < mean_signal/1000.
            fprintf('Very close to 0 relative to original signal order (%d), DC offset removed sucessfully!',mean_signal)
        end
        fprintf('\n')

        % Plot original vs. filtered signal of each channel
        fig = figure();
        fig.Position = [50 50 1600 400];
        plot(time,ecg_(:,i),'b')
        hold on
        plot(time,filtered_signal(:,i),'r'), 
        title(['Channel ',num2str(i),' - Original and filtered ECG signals'],'FontSize', 16);
        ylabel('ECG signal (Voltage - unknown scale)','FontSize', 14);xlabel('Time (s)','FontSize', 14);
        legend('Original','Preprocessed','FontSize', 10)
    end
end
fprintf('Please, zoom in to observe signals of channel 1 better!')
