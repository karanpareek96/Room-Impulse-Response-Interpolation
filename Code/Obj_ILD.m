% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the Interaural Level Difference of the IRs using
% the following interpolation methods:
% 1. Linear
% 2. Discrete Fourier Transform
% 3. Time Difference
% 4. Dynamic Time Warping and Decorrelation
% 5. Vector Base Amplitude Panning
% 6. Vector Base Intensity Panning
%
% References
% [1] Kearney, G., Masterson, C., Adams, S., Boland, F. (2009). “Dynamic Time 
%     Warping for Acoustic Response Interpolation: Possibilities and Limitations.” 
%     Signal Processing Conference, 2009 17th European, pp. 705- 709.

function s = Obj_ILD(roomType,folder,method)

%% Initialization

if method == 1
    [IR_L,IR_R] = import_IR_mat_data_1(folder);
    [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_1(roomType);
elseif method == 2
    [IR_L,IR_R] = import_IR_mat_data_2(folder);
    [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_2(roomType);
elseif method == 3
    [IR_L,IR_R] = import_IR_mat_data_3(folder);
    [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_3(roomType);
end

L = dimensions(1);
W = dimensions(2);
H = dimensions(3);

% Normalizaing the audio signal
if max(max(abs(IR_L))) > max(max(abs(IR_R)))
    IR_L = IR_L / max(max(abs(IR_L)));
    IR_R = IR_R / max(max(abs(IR_L)));
elseif max(max(abs(IR_R))) > max(max(abs(IR_L)))
    IR_L = IR_L / max(max(abs(IR_R)));
    IR_R = IR_R / max(max(abs(IR_R)));
end

% Filtering parameters
cutoffFreq = 2000; % Defining the cutoff frequency
normFreq = cutoffFreq /(44100/2); % Converting it into normalized frequency
filtOrder = 4; % Defining the filter order
[b_coeff, a_coeff] = butter(filtOrder, normFreq, 'high'); % Formation of the filter

%% Actual IRs

% Filtering the IRs
IR_L = filter(b_coeff, a_coeff, IR_L);
IR_R = filter(b_coeff, a_coeff, IR_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));

end

% ILD calculation
act_ILD = zeros(size(IR_L));

for c = 1:size(IR_L,2)
    
    act_ILD(:,c) =+ 20*log(abs(Fx_act_L(:,c)) ./ abs(Fx_act_R(:,c)));
    
end

%% Linear Method

[intp_linear_L,intp_linear_R] = Interp_Linear(folder,angles_A,method);

% Normalizaing the audio signal
if max(max(abs(intp_linear_L))) > max(max(abs(intp_linear_R)))
    intp_linear_L = intp_linear_L / max(max(abs(intp_linear_L)));
    intp_linear_R = intp_linear_R / max(max(abs(intp_linear_L)));
elseif max(max(abs(intp_linear_R))) > max(max(abs(intp_linear_L)))
    intp_linear_L = intp_linear_L / max(max(abs(intp_linear_R)));
    intp_linear_R = intp_linear_R / max(max(abs(intp_linear_R)));
end

% Filtering the IRs
intp_linear_L = filter(b_coeff, a_coeff, intp_linear_L);
intp_linear_R = filter(b_coeff, a_coeff, intp_linear_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_int_linear_L = zeros(size(intp_linear_L));
Fx_int_linear_R = zeros(size(intp_linear_R));

for n = 1:size(Fx_int_linear_L,2)
    
    Fx_int_linear_L(:,n) =+ fft(intp_linear_L(:,n),size(intp_linear_L,1));
    Fx_int_linear_R(:,n) =+ fft(intp_linear_R(:,n),size(intp_linear_R,1));
    
end

% ILD calculation
linear_ILD = zeros(size(intp_linear_L));

for c = 1:size(Fx_int_linear_L,2)
    
    linear_ILD(:,c) =+ 20*log(abs(Fx_int_linear_L(:,c)) ./ abs(Fx_int_linear_R(:,c)));
    
end

%% DFT Interpolation Method

[intp_dft_L,intp_dft_R] = Interp_DFT(folder,method);

% Normalizaing the audio signal
if max(max(abs(intp_dft_L))) > max(max(abs(intp_dft_R)))
    intp_dft_L = intp_dft_L / max(max(abs(intp_dft_L)));
    intp_dft_R = intp_dft_R / max(max(abs(intp_dft_L)));
elseif max(max(abs(intp_dft_R))) > max(max(abs(intp_dft_L)))
    intp_dft_L = intp_dft_L / max(max(abs(intp_dft_R)));
    intp_dft_R = intp_dft_R / max(max(abs(intp_dft_R)));
end

% Filtering the IRs
intp_dft_L = filter(b_coeff, a_coeff, intp_dft_L);
intp_dft_R = filter(b_coeff, a_coeff, intp_dft_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_int_dft_L = zeros(size(intp_dft_L));
Fx_int_dft_R = zeros(size(intp_dft_R));

for n = 1:size(intp_dft_L,2)
   
    Fx_int_dft_L(:,n) =+ fft(intp_dft_L(:,n),size(intp_dft_L,1));
    Fx_int_dft_R(:,n) =+ fft(intp_dft_R(:,n),size(intp_dft_R,1));
    
end

% ILD calculation
dft_ILD = zeros(size(intp_dft_L));

for c = 1:size(intp_dft_L,2)

    dft_ILD(:,c) =+ 20*log(abs(Fx_int_dft_L(:,c)) ./ abs(Fx_int_dft_R(:,c)));
    
end

%% Time Differnce Analysis

[intp_tdiff_L,intp_tdiff_R] = Interp_TimeDifference(folder,angles_A,method);

% Normalizaing the audio signal
if max(max(abs(intp_tdiff_L))) > max(max(abs(intp_tdiff_R)))
    intp_tdiff_L = intp_tdiff_L / max(max(abs(intp_tdiff_L)));
    intp_tdiff_R = intp_tdiff_R / max(max(abs(intp_tdiff_L)));
elseif max(max(abs(intp_tdiff_R))) > max(max(abs(intp_tdiff_L)))
    intp_tdiff_L = intp_tdiff_L / max(max(abs(intp_tdiff_R)));
    intp_tdiff_R = intp_tdiff_R / max(max(abs(intp_tdiff_R)));
end

% Filtering the IRs
intp_tdiff_L = filter(b_coeff, a_coeff, intp_tdiff_L);
intp_tdiff_R = filter(b_coeff, a_coeff, intp_tdiff_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_int_tdiff_L = zeros(size(intp_tdiff_L));
Fx_int_tdiff_R = zeros(size(intp_tdiff_R));

for n = 1:size(intp_tdiff_L,2)
    
    Fx_int_tdiff_L(:,n) =+ fft(intp_tdiff_L(:,n),size(intp_tdiff_L,1));
    Fx_int_tdiff_R(:,n) =+ fft(intp_tdiff_R(:,n),size(intp_tdiff_R,1));
    
end

% ILD calculation
tdiff_ILD = zeros(size(intp_tdiff_L));

for c = 1:size(intp_tdiff_L,2)
    
    tdiff_ILD(:,c) =+ 20*log(abs(Fx_int_tdiff_L(:,c)) ./ abs(Fx_int_tdiff_R(:,c)));
    
end


%% Dynamic Time Warping and Decorrelation Method

[intp_dtw_L,intp_dtw_R] = Interp_DTW_DCR(folder,angles_B,angles_C,L,W,H,method);

% Normalizaing the audio signal
if max(max(abs(intp_dtw_L))) > max(max(abs(intp_dtw_R)))
    intp_dtw_L = intp_dtw_L / max(max(abs(intp_dtw_L)));
    intp_dtw_R = intp_dtw_R / max(max(abs(intp_dtw_L)));
elseif max(max(abs(intp_dtw_R))) > max(max(abs(intp_dtw_L)))
    intp_dtw_L = intp_dtw_L / max(max(abs(intp_dtw_R)));
    intp_dtw_R = intp_dtw_R / max(max(abs(intp_dtw_R)));
end

% Filtering the IRs
intp_dtw_L = filter(b_coeff, a_coeff, intp_dtw_L);
intp_dtw_R = filter(b_coeff, a_coeff, intp_dtw_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_int_dtw_L = zeros(size(intp_dtw_L));
Fx_int_dtw_R = zeros(size(intp_dtw_R));

for n = 1:size(intp_dtw_L,2)
  
    Fx_int_dtw_L(:,n) =+ fft(intp_dtw_L(:,n),size(intp_dtw_L,1));
    Fx_int_dtw_R(:,n) =+ fft(intp_dtw_R(:,n),size(intp_dtw_R,1));
    
end

% ILD calculation
dtw_ILD = zeros(size(intp_dtw_L));

for c = 1:size(intp_dtw_L,2)
    
    dtw_ILD(:,c) =+ 20*log(abs(Fx_int_dtw_L(:,c)) ./ abs(Fx_int_dtw_R(:,c)));
    
end

%% VBAP Method

[intp_vbap_L,intp_vbap_R] = Interp_VBAP(folder,angles_D,method);

% Normalizaing the audio signal
if max(max(abs(intp_vbap_L))) > max(max(abs(intp_vbap_R)))
    intp_vbap_L = intp_vbap_L / max(max(abs(intp_vbap_L)));
    intp_vbap_R = intp_vbap_R / max(max(abs(intp_vbap_L)));
elseif max(max(abs(intp_vbap_R))) > max(max(abs(intp_vbap_L)))
    intp_vbap_L = intp_vbap_L / max(max(abs(intp_vbap_R)));
    intp_vbap_R = intp_vbap_R / max(max(abs(intp_vbap_R)));
end

% Filtering the IRs
intp_vbap_L = filter(b_coeff, a_coeff, intp_vbap_L);
intp_vbap_R = filter(b_coeff, a_coeff, intp_vbap_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_int_vbap_L = zeros(size(intp_vbap_L));
Fx_int_vbap_R = zeros(size(intp_vbap_R));

for n = 1:size(intp_vbap_L,2)
    
    Fx_int_vbap_L(:,n) =+ fft(intp_vbap_L(:,n),size(intp_vbap_L,1));
    Fx_int_vbap_R(:,n) =+ fft(intp_vbap_R(:,n),size(intp_vbap_R,1));
    
end

% ILD calculation
vbap_ILD = zeros(size(intp_vbap_L));

for c = 1:size(intp_vbap_L,2)
    
    vbap_ILD(:,c) =+ 20*log(abs(Fx_int_vbap_L(:,c)) ./ abs(Fx_int_vbap_R(:,c)));
    
end

%% VBIP Method

[intp_vbip_L,intp_vbip_R] = Interp_VBIP(folder,angles_D,method);

% Normalizaing the audio signal
if max(max(abs(intp_vbip_L))) > max(max(abs(intp_vbip_R)))
    intp_vbip_L = intp_vbip_L / max(max(abs(intp_vbip_L)));
    intp_vbip_R = intp_vbip_R / max(max(abs(intp_vbip_L)));
elseif max(max(abs(intp_vbip_R))) > max(max(abs(intp_vbip_L)))
    intp_vbip_L = intp_vbip_L / max(max(abs(intp_vbip_R)));
    intp_vbip_R = intp_vbip_R / max(max(abs(intp_vbip_R)));
end

% Filtering the IRs
intp_vbip_L = filter(b_coeff, a_coeff, intp_vbip_L);
intp_vbip_R = filter(b_coeff, a_coeff, intp_vbip_R);

% Transforming the IRs and interpolated IRs into the frequency domain
Fx_int_vbip_L = zeros(size(intp_vbip_L));
Fx_int_vbip_R = zeros(size(intp_vbip_R));

for n = 1:size(intp_vbip_L,2)
    
    Fx_int_vbip_L(:,n) =+ fft(intp_vbip_L(:,n),size(intp_vbip_L,1));
    Fx_int_vbip_R(:,n) =+ fft(intp_vbip_R(:,n),size(intp_vbip_R,1));
    
end

% ILD calculation
vbip_ILD = zeros(size(intp_vbip_L));

for c = 1:size(intp_vbip_L,2)

    vbip_ILD(:,c) =+ 20*log(abs(Fx_int_vbip_L(:,c)) ./ abs(Fx_int_vbip_R(:,c)));
    
end

%% Plots

figure;
%{
subplot(2,3,1);
plot(mean(linear_ILD),'b','LineWidth',3);
hold on;
plot(mean(act_ILD),'--');
title(strcat('Interaural Level Difference - Linear',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ILD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Linear','Dataset');
%}

subplot(2,2,1);
plot(mean(dft_ILD),'k','LineWidth',3);
hold on;
plot(mean(act_ILD),'--');
title(strcat('Interaural Level Difference - DFT',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ILD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('DFT','Dataset');

subplot(2,2,2);
plot(mean(tdiff_ILD),'r','LineWidth',3);
hold on;
plot(mean(act_ILD),'--');
title(strcat('Interaural Level Difference - Time Diff',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ILD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Time Diff','Dataset');

subplot(2,2,3);
plot(mean(dtw_ILD),'m','LineWidth',3);
hold on;
plot(mean(act_ILD),'--');
title(strcat('Interaural Level Difference - DTW',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ILD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('DTW','Dataset');

subplot(2,2,4);
plot(mean(vbap_ILD),'g','LineWidth',3);
hold on;
plot(mean(act_ILD),'--');
title(strcat('Interaural Level Difference - VBAP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ILD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('VBAP','Dataset');

%{
subplot(2,3,6);
plot(mean(vbip_ILD),'c','LineWidth',3);
hold on;
plot(mean(act_ILD),'--');
title(strcat('Interaural Level Difference - VBIP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ILD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('VBIP','Dataset');
%}

%% Calculating Statistics

% Measuring deviation of interpolated set from original set

% DFT
abs_error_dft = abs(mean(act_ILD) - mean(dft_ILD));
mean_dft = mean(abs_error_dft);
std_dft = std(abs_error_dft);

% DTW
abs_error_dtw = abs(mean(act_ILD) - mean(dtw_ILD));
mean_dtw = mean(abs_error_dtw);
std_dtw = std(abs_error_dtw);

% Time Difference
abs_error_tdiff = abs(mean(act_ILD) - mean(tdiff_ILD));
mean_tdiff = mean(abs_error_tdiff);
std_tdiff = std(abs_error_tdiff);

% VBAP
abs_error_vbap = abs(mean(act_ILD) - mean(vbap_ILD));
mean_vbap = mean(abs_error_vbap);
std_vbap = std(abs_error_vbap);

s = {strcat(num2str(method),'_',roomType),'mean','std'; 'dft',mean_dft,std_dft; ...
        'dtw',mean_dtw,std_dtw; 'tdiff',mean_tdiff,std_tdiff; 'vbap',mean_vbap,std_vbap};
        
end