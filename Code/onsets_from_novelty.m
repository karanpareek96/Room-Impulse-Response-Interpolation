% Name: Karan Pareek
% Net ID: kp2218
%
% This function computes the peak picking parameters for the rectified
% spectral flux novely function.
% 
% INPUT: Novelty function (n_t), Time array (t), Sample rate (fs), Cutoff
%        frequency (w_c), Length of median filter (medfilt_len), Threshold 
%        offset value (offset)
% OUTPUT: Onset amplitude(onset_a), Onset time (onset_t), Novelty function
%         (n_t_norm), Threshold value (thresh)
% 
% References
% [1] Duxbury, C., Sandler, M., Davies, M. (2002). “A Hybrid Approach to Musical 
%     Note Onset Detection.” Proc. Digital Audio Effects Conf. (DAFX,’02), 
%     Hamburg, Germany, pp. 33–38.

function [onset_a, onset_t, n_t_norm, thresh] = onsets_from_novelty(n_t, t, fs, w_c, medfilt_len, offset)

%% Smoothing

% Smoothing the novelty function using a Butterworth filter with cutoff
% frequency 'w_c'

normFreq = w_c/(fs/2);

% This gives us the 'b' and 'a' coefficients
[b, a] = butter(1, normFreq); 

% Applying the first order Butterworth filter
n_t_smoothed = filtfilt(b, a, n_t);

%% Normalizing

% Normalizing the novelty function
n_t_norm = n_t_smoothed/max(abs(n_t_smoothed));

%% Adaptive Threshold

% In order to derive the adaptive threshold for the novelty function,
% median filtering is added to the smoothed function and an offset is
% created. 
thresh = offset + medfilt1(n_t_norm,medfilt_len);

% Given the offset value and the median smoothed function, the onsets are
% detected simply by using a local maxima.
[onset_a,onset_t] = findpeaks(n_t_norm-thresh,fs);

end