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

[1] Goldberger, Ary & Amaral, Luís & Glass, Leon & Hausdorff, Jeffrey & Ivanov, Plamen & Mark, Roger & Mietus, Joseph & Moody, George & Peng, Chung-Kang & Stanley, H.. 2000. PhysioBank, PhysioToolkit, and PhysioNet : Components of a New Research Resource for Complex Physiologic Signals. Circulation. 101. E215-20. 10.1161/01.CIR.101.23.e215. 

[2] Rahul Kher. 2019. Signal Processing Techniques for Removing Noise from ECG Signals. J Biomed Eng 1: 1-9.

[3] Christov I, Neycheva T, Schmid R, Stoyanov T, Abächerli R. 2017. Pseudo-real-time low-pass filter in ECG, self-adjustable to the frequency spectra of the waves. Med Biol Eng Comput. ;55(9):1579-1588. doi: 10.1007/s11517-017-1625-y.

[4] Parola, Franco & García-Niebla, Javier. 2017. Use of High-Pass and Low-Pass Electrocardiographic Filters in an International Cardiological Community and Possible Clinical Effects. Advanced Journal of Vascular Medicine. 2. 34-38. 
