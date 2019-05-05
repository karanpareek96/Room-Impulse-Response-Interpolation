% Name: Karan Pareek
% Net ID: kp2218
%
% This function computes the rectified spectral flux novelty function.
% 
% INPUT: Input signal (x_t), Time array (t), Sample rate (fs), Window size
%        (win_size), Hop size (hop_size)
% OUTPUT: Novelty function (n_t_sf), Time array (t_sf), Sample rate (fs_sf)
% 
% References
% [1] Duxbury, C., Sandler, M., Davies, M. (2002). “A Hybrid Approach to Musical 
%     Note Onset Detection.” Proc. Digital Audio Effects Conf. (DAFX,’02), 
%     Hamburg, Germany, pp. 33–38.

function [n_t_sf, t_sf, fs_sf] = compute_novelty_sf(x_t, t, fs, win_size, hop_size)

%% Input Checking

if win_size < 0
    error('Window Length cannot be less than 0');
elseif hop_size >= win_size
    error('Invalid Overlap Length');
end

%% Buffer Function

% Since the computation of the spectral flux occurs in the frequency
% domain, the function will first compute the STFT of the input audio
% signal based on the window and hop length and then proceed with the
% spectral flux calculation.

% We define a variable 'x_buf' that calculates the buffer function for our
% signal 'x' with a length of 'winLength' and 'overlapLength'.

noverlap = win_size - hop_size;
x_buf = buffer(x_t,win_size,noverlap);
n_buf = size(x_buf,2);

%% Windowing

W = window(@hamming, win_size);

% We create a new matrix W that has horizontal length 'n_buf' such that each
% element of 'x_buf' is now multiplied with the window matrix that give us 
% the final windowed signal for conducting the STFT.

W = repmat(W,1,n_buf);
x_win = x_buf .* W; 

%% Computing the FFT of the signal

nfft = win_size;
Fx = fft(x_win,nfft);

% To get the desired form of the STFT result, we first take the absolute
% value of the first half of the function, double it in length and divide
% it by the NFFT parameter to get the final value

Fx = abs(Fx(1:nfft/2 + 1,:));

%% Spectral Flux

% Now that the STFT of the input file has been calculated, the function
% will proceed with the calculation of the spectral flux.

% Calculating the difference between successive columns
specDiff = diff(Fx,1,2);

% Summing all elements from 1 to N/2
specDiff = specDiff((1:win_size/2+1),:);
n_t_sf = sum(specDiff);

% Performing Half wave rectificatio such that the H(x+|x|) = max(0,x)
for n = 1:length(n_t_sf)
    
    if n_t_sf(n) < 0
        
        n_t_sf(n) = 0;
        
    end
    
end

% Deriving the value of the Spectral Flux (Half Wave Rectification)
n_t_sf = 2/win_size * n_t_sf;

% Defining the time array and the sample rate of the novelty function
t_sf = t(1):(hop_size/fs):(length(n_t_sf)-1)/(fs/hop_size);
fs_sf = fs/hop_size;

end