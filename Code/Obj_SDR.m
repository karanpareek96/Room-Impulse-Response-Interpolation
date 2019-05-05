% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the Signal-to-Distortion ratio of the IRs using
% the following interpolation methods:
% 1. Linear
% 2. Discrete Fourier Transform
% 3. Time Difference
% 4. Dynamic Time Warping and Decorrelation
% 5. Vector Base Amplitude Panning
% 6. Vector Base Intensity Panning
%
% References
% [1] ﻿Matsumoto, M., Yamanaka, S., Toyama, M., Nomura, H. (2004). “Effect 
%      of Arrival Time Correction on the Accuracy of Binaural Impulse Response 
%      Interpolation - Interpolation Methods of Binaural Response.” Journal 
%      of the Audio Engineering Society, 52(1/2), pp. 56-61.

function s = Obj_SDR(roomType,folder,method)

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

% SDR Measure (Linear)

act_sq_linear_L = zeros(size(IR_L));
act_sq_linear_R = zeros(size(IR_R));

diff_sq_linear_L = zeros(size(IR_L));
diff_sq_linear_R = zeros(size(IR_R));

% SDR matrices
for a = 1:size(IR_L,2)
    
    % Numerator
    act_sq_linear_L(:,a) =+ IR_L(:,a) .^2;
    act_sq_linear_R(:,a) =+ IR_R(:,a) .^2;
    
    % Denominator
    diff_sq_linear_L(:,a) =+ (IR_L(:,a) - intp_linear_L(:,a)) .^2;
    diff_sq_linear_R(:,a) =+ (IR_R(:,a) - intp_linear_R(:,a)) .^2;

end

SDR_linear_L = 10*log(sum(act_sq_linear_L) ./ sum(diff_sq_linear_L));
SDR_linear_R = 10*log(sum(act_sq_linear_R) ./ sum(diff_sq_linear_R));

%% DFT Method

[intp_dft_L,intp_dft_R] = Interp_DFT(folder,method);

% Normalizaing the audio signal
if max(max(abs(intp_dft_L))) > max(max(abs(intp_dft_R)))
    intp_dft_L = intp_dft_L / max(max(abs(intp_dft_L)));
    intp_dft_R = intp_dft_R / max(max(abs(intp_dft_L)));
elseif max(max(abs(intp_dft_R))) > max(max(abs(intp_dft_L)))
    intp_dft_L = intp_dft_L / max(max(abs(intp_dft_R)));
    intp_dft_R = intp_dft_R / max(max(abs(intp_dft_R)));
end

% SDR Measure (DFT)

act_sq_dft_L = zeros(size(IR_L));
act_sq_dft_R = zeros(size(IR_R));

diff_sq_dft_L = zeros(size(IR_L));
diff_sq_dft_R = zeros(size(IR_R));

% SDR matrices
for a = 1:size(IR_L,2)
    
    % Numerator
    act_sq_dft_L(:,a) =+ IR_L(:,a) .^2;
    act_sq_dft_R(:,a) =+ IR_R(:,a) .^2;
    
    % Denominator
    diff_sq_dft_L(:,a) =+ (IR_L(:,a) - intp_dft_L(:,a)) .^2;
    diff_sq_dft_R(:,a) =+ (IR_R(:,a) - intp_dft_R(:,a)) .^2;

end

SDR_dft_L = 10*log(sum(act_sq_dft_L) ./ sum(diff_sq_dft_L));
SDR_dft_R = 10*log(sum(act_sq_dft_R) ./ sum(diff_sq_dft_R));

%% Time Difference Method

[intp_tdiff_L,intp_tdiff_R] = Interp_TimeDifference(folder,angles_A,method);

% Normalizaing the audio signal
if max(max(abs(intp_tdiff_L))) > max(max(abs(intp_tdiff_R)))
    intp_tdiff_L = intp_tdiff_L / max(max(abs(intp_tdiff_L)));
    intp_tdiff_R = intp_tdiff_R / max(max(abs(intp_tdiff_L)));
elseif max(max(abs(intp_tdiff_R))) > max(max(abs(intp_tdiff_L)))
    intp_tdiff_L = intp_tdiff_L / max(max(abs(intp_tdiff_R)));
    intp_tdiff_R = intp_tdiff_R / max(max(abs(intp_tdiff_R)));
end

% SDR Measure (Time Diff)

act_sq_tdiff_L = zeros(size(IR_L));
act_sq_tdiff_R = zeros(size(IR_R));

diff_sq_tdiff_L = zeros(size(IR_L));
diff_sq_tdiff_R = zeros(size(IR_R));

% SDR matrices
for a = 1:size(IR_L,2)
    
    % Numerator
    act_sq_tdiff_L(:,a) =+ IR_L(:,a) .^2;
    act_sq_tdiff_R(:,a) =+ IR_R(:,a) .^2;
    
    % Denominator
    diff_sq_tdiff_L(:,a) =+ (IR_L(:,a) - intp_tdiff_L(:,a)) .^2;
    diff_sq_tdiff_R(:,a) =+ (IR_R(:,a) - intp_tdiff_R(:,a)) .^2;

end

SDR_tdiff_L = 10*log(sum(act_sq_tdiff_L) ./ sum(diff_sq_tdiff_L));
SDR_tdiff_R = 10*log(sum(act_sq_tdiff_R) ./ sum(diff_sq_tdiff_R));

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

% SDR Measure (DTW)

act_sq_dtw_L = zeros(size(IR_L));
act_sq_dtw_R = zeros(size(IR_R));

diff_sq_dtw_L = zeros(size(IR_L));
diff_sq_dtw_R = zeros(size(IR_R));

% SDR matrices
for a = 1:size(IR_L,2)
    
    % Numerator
    act_sq_dtw_L(:,a) =+ IR_L(:,a) .^2;
    act_sq_dtw_R(:,a) =+ IR_R(:,a) .^2;
    
    % Denominator
    diff_sq_dtw_L(:,a) =+ (IR_L(:,a) - intp_dtw_L(:,a)) .^2;
    diff_sq_dtw_R(:,a) =+ (IR_R(:,a) - intp_dtw_R(:,a)) .^2;

end

SDR_dtw_L = 10*log(sum(act_sq_dtw_L) ./ sum(diff_sq_dtw_L));
SDR_dtw_R = 10*log(sum(act_sq_dtw_R) ./ sum(diff_sq_dtw_R));

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

% SDR Measure (VBAP)

act_sq_vbap_L = zeros(size(IR_L));
act_sq_vbap_R = zeros(size(IR_R));

diff_sq_vbap_L = zeros(size(IR_L));
diff_sq_vbap_R = zeros(size(IR_R));

% SDR matrices
for a = 1:size(IR_L,2)
    
    % Numerator
    act_sq_vbap_L(:,a) =+ IR_L(:,a) .^2;
    act_sq_vbap_R(:,a) =+ IR_R(:,a) .^2;
    
    % Denominator
    diff_sq_vbap_L(:,a) =+ (IR_L(:,a) - intp_vbap_L(:,a)) .^2;
    diff_sq_vbap_R(:,a) =+ (IR_R(:,a) - intp_vbap_R(:,a)) .^2;

end

SDR_vbap_L = 10*log(sum(act_sq_vbap_L) ./ sum(diff_sq_vbap_L));
SDR_vbap_R = 10*log(sum(act_sq_vbap_R) ./ sum(diff_sq_vbap_R));

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

% SDR Measure (VBIP)

act_sq_vbip_L = zeros(size(IR_L));
act_sq_vbip_R = zeros(size(IR_R));

diff_sq_vbip_L = zeros(size(IR_L));
diff_sq_vbip_R = zeros(size(IR_R));

% SDR matrices
for a = 1:size(IR_L,2)
    
    % Numerator
    act_sq_vbip_L(:,a) =+ IR_L(:,a) .^2;
    act_sq_vbip_R(:,a) =+ IR_R(:,a) .^2;
    
    % Denominator
    diff_sq_vbip_L(:,a) =+ (IR_L(:,a) - intp_vbip_L(:,a)) .^2;
    diff_sq_vbip_R(:,a) =+ (IR_R(:,a) - intp_vbip_R(:,a)) .^2;

end

SDR_vbip_L = 10*log(sum(act_sq_vbip_L) ./ sum(diff_sq_vbip_L));
SDR_vbip_R = 10*log(sum(act_sq_vbip_R) ./ sum(diff_sq_vbip_R));

%% Plots

figure;
%{
subplot(2,3,1);
plot(SDR_linear_L,'LineWidth',3);
hold on;
plot(SDR_linear_R,'LineWidth',3);
title(strcat('Signal-Distortion Ratio - Linear',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Signal-to-Distortion Ratio');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');
%}

subplot(2,2,1);
plot(SDR_dft_L,'LineWidth',3);
hold on;
plot(SDR_dft_R,'LineWidth',3);
title(strcat('Signal-Distortion Ratio - DFT',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Signal-to-Distortion Ratio');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

subplot(2,2,2);
plot(SDR_tdiff_L,'LineWidth',3);
hold on;
plot(SDR_tdiff_R,'LineWidth',3);
title(strcat('Signal-Distortion Ratio - Time Diff',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Signal-to-Distortion Ratio');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

subplot(2,2,3);
plot(SDR_dtw_L,'LineWidth',3);
hold on;
plot(SDR_dtw_R,'LineWidth',3);
title(strcat('Signal-Distortion Ratio - DTW',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Signal-to-Distortion Ratio');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

subplot(2,2,4);
plot(SDR_vbap_L,'LineWidth',3);
hold on;
plot(SDR_vbap_R,'LineWidth',3);
title(strcat('Signal-Distortion Ratio - VBAP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Signal-to-Distortion Ratio');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

%{
subplot(2,3,6);
plot(SDR_vbip_L,'LineWidth',3);
hold on;
plot(SDR_vbip_R,'LineWidth',3);
title(strcat('Signal-Distortion Ratio - VBIP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Signal-to-Distortion Ratio');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');
%}

%% Calculating Statistics

% Measuring deviation of interpolated set from original set

% DFT
mean_dft_L = mean(SDR_dft_L);
std_dft_L = std(SDR_dft_L);
mean_dft_R = mean(SDR_dft_R);
std_dft_R = std(SDR_dft_R);

% DTW
mean_dtw_L = mean(SDR_dtw_L);
std_dtw_L = std(SDR_dtw_L);
mean_dtw_R = mean(SDR_dtw_R);
std_dtw_R = std(SDR_dtw_R);

% Time Difference
mean_tdiff_L = mean(SDR_tdiff_L);
std_tdiff_L = std(SDR_tdiff_L);
mean_tdiff_R = mean(SDR_tdiff_R);
std_tdiff_R = std(SDR_tdiff_R);

% VBAP
mean_vbap_L = mean(SDR_vbap_L);
std_vbap_L = std(SDR_vbap_L);
mean_vbap_R = mean(SDR_vbap_R);
std_vbap_R = std(SDR_vbap_R);

s = {strcat(num2str(method),'_',roomType),'mean(L)','std(L)','mean(R)','std(R)'; ...
        'dft',mean_dft_L,std_dft_L,mean_dft_R,std_dft_R; ...
        'dtw',mean_dtw_L,std_dtw_L,mean_dtw_R,std_dtw_R; ...
        'tdiff',mean_tdiff_L,std_tdiff_L,mean_tdiff_R,std_tdiff_R; ...
        'vbap',mean_vbap_L,std_vbap_L,mean_vbap_R,std_vbap_R};
    
end