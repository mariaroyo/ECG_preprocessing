# ECG signal preprocessing

In the present code, an ECG signal is preprocessed through: <br/>
- Recording spikes (artifacts of great amplitude) removal.<br/>
- Low-pass filtering.<br/>
- Powerline interference filtering.<br/>
- Baseline wander and offset removal.<br/>
The code also detects whether there is any disconnected channel.<br/>

Main: ECG_preprocessing.mat<br/>

Functions:<br/>
- filter_signal.mat: low or high pass filter.<br/>
- notch_filter.mat: to remove powerline interference.<br/>
- plot_filtered_signal.mat: to plot the original vs. filtered signals.<br/>
