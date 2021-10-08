% -------------------------------------------------------
% Function used to plot the original vs. filtered signals obtained in different channels.
%
% Inputs:
%   time: time vector
%   signal: original signal. Matrix of nxm dimensions, n being the number of samples and m the number of channels.
%   filtered_signal: filtered signal. Same dimensions as signal.
%   figure_title: title of the figure and label of the filtered signal.
%
% Outputs:
%   -
% -------------------------------------------------------

function []=plot_filtered_signal(time,signal,filtered_signal,figure_title)

[~,channels] = size(signal);

fig = figure();
fig.Position = [100 100 1200 800];
for i = 1:channels
    subplot (channels, 1, i); 
    h1=plot(time,signal(:,i),'b');title(['Channel ',num2str(i)],'FontSize', 12)%,xlabel('Time (s)'),ylabel('ECG signal (Voltage - unknown scale)')
    hold on
    h2=plot(time,filtered_signal(:,i),'r');
end
han=axes(fig,'visible','off'); han.Title.Visible='on';han.XLabel.Visible='on';han.YLabel.Visible='on';
ylabel(han,'ECG signal (Voltage - unknown scale)','FontSize', 13);xlabel(han,'Time (s)','FontSize', 13); sgtitle([figure_title,' ECG signals']);

hL = legend([h1,h2],{'Original',figure_title},'FontSize', 10);
newPosition = [0.8 0.9 0.03 0.03]; % Move the Legend
newUnits = 'normalized';
set(hL,'Position', newPosition,'Units', newUnits);
