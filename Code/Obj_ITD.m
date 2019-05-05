% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the Interaural Time Difference of the IRs using
% the following interpolation methods:
% 1. Linear
% 2. Discrete Fourier Transform
% 3. Time Difference
% 4. Dynamic Time Warping and Decorrelation
% 5. Vector Base Amplitude Panning
% 6. Vector Base Intensity Panning
%
% References
% [1] 

function s = Obj_ITD(roomType,folder,method)

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
[b_coeff, a_coeff] = butter(filtOrder, normFreq, 'low'); % Formation of the filter

%% Actual IRs

% Filtering the IRs
IR_L = filter(b_coeff, a_coeff, IR_L);
IR_R = filter(b_coeff, a_coeff, IR_R);

act_ITD = zeros(1,size(IR_L,2));

% ITD calculation
for n = 1:size(IR_L,2)
    
    act_ITD(n) = compute_ITD([IR_L(:,n),IR_R(:,n)]);
    
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

linear_ITD = zeros(1,size(intp_linear_L,2));

% ITD calculation
for n = 1:size(intp_linear_L,2)
    
    linear_ITD(n) = compute_ITD([intp_linear_L(:,n),intp_linear_R(:,n)]);
    
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

dft_ITD = zeros(1,size(intp_dft_L,2));

% ITD calculation
for n = 1:size(intp_dft_L,2)
    
    dft_ITD(n) = compute_ITD([intp_dft_L(:,n),intp_dft_R(:,n)]);
    
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

tdiff_ITD = zeros(1,size(intp_tdiff_L,2));

% ITD calculation
for n = 1:size(intp_tdiff_L,2)
    
    tdiff_ITD(n) = compute_ITD([intp_tdiff_L(:,n),intp_tdiff_R(:,n)]);
    
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

dtw_ITD = zeros(1,size(intp_dtw_L,2));

% ITD calculation
for n = 1:size(intp_dtw_L,2)
    
    dtw_ITD(n) = compute_ITD([intp_dtw_L(:,n),intp_dtw_R(:,n)]);
    
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

vbap_ITD = zeros(1,size(intp_vbap_L,2));

% ITD calculation
for n = 1:size(intp_vbap_L,2)
    
    vbap_ITD(n) = compute_ITD([intp_vbap_L(:,n),intp_vbap_R(:,n)]);
    
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

vbip_ITD = zeros(1,size(intp_vbip_L,2));

% ITD calculation
for n = 1:size(intp_vbip_L,2)
    
    vbip_ITD(n) = compute_ITD([intp_vbip_L(:,n),intp_vbip_R(:,n)]);
    
end

%% Plots

figure;
%{
subplot(2,3,1);
plot(linear_ITD,'b','LineWidth',3);
hold on;
plot(act_ITD,'--');
title(strcat('Interaural Time Differece - Linear',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ITD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Linear','Dataset');
%}

subplot(2,2,1);
plot(dft_ITD,'k','LineWidth',3);
hold on;
plot(act_ITD,'--');
title(strcat('Interaural Time Difference - DFT',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ITD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('DFT','Dataset');

subplot(2,2,2);
plot(tdiff_ITD,'r','LineWidth',3);
hold on;
plot(act_ITD,'--');
title(strcat('Interaural Time Difference - Time Diff',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ITD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Time Diff','Dataset');

subplot(2,2,3);
plot(dtw_ITD,'m','LineWidth',3);
hold on;
plot(act_ITD,'--');
title(strcat('Interaural Time Difference - DTW',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ITD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('DTW','Dataset');

subplot(2,2,4);
plot(vbap_ITD,'g','LineWidth',3);
hold on;
plot(act_ITD,'--');
title(strcat('Interaural Time Difference - VBAP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ITD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('VBAP','Dataset');

%{
subplot(2,3,6);
plot(vbip_ITD,'c','LineWidth',3);
hold on;
plot(act_ITD,'--');
title(strcat('Interaural Time Difference - VBIP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('ITD');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('VBIP','Dataset');
%}

%% Calculating Statistics

% Measuring deviation of interpolated set from original set

% DFT
abs_error_dft = abs(act_ITD - dft_ITD);
mean_dft = mean(abs_error_dft);
std_dft = std(abs_error_dft);

% DTW
abs_error_dtw = abs(act_ITD - dtw_ITD);
mean_dtw = mean(abs_error_dtw);
std_dtw = std(abs_error_dtw);

% Time Difference
abs_error_tdiff = abs(act_ITD - tdiff_ITD);
mean_tdiff = mean(abs_error_tdiff);
std_tdiff = std(abs_error_tdiff);

% VBAP
abs_error_vbap = abs(act_ITD - vbap_ITD);
mean_vbap = mean(abs_error_vbap);
std_vbap = std(abs_error_vbap);

s = {strcat(num2str(method),'_',roomType),'mean','std'; 'dft',mean_dft,std_dft; ...
        'dtw',mean_dtw,std_dtw; 'tdiff',mean_tdiff,std_tdiff; 'vbap',mean_vbap,std_vbap};
    
end