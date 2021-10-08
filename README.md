# ECG signal preprocessing

In the main script an ECG signal is preprocessed through:
• Recording spikes (artifacts of great amplitude) removal.
• Low-pass filtering.
• Powerline interference filtering.
• Baseline wander and offset removal.
The code also detects whether there is any disconnected channel.

Main: ECG_preprocessing.mat
Functions:
  filter_signal.mat: low or high pass filter
  notch_filter.mat: to remove powerline interference
  plot_filtered_signal.mat: to plot the original vs. filtered signals
