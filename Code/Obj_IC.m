% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the Interaural Coherence of the IRs using
% the following interpolation methods:
% 1. Linear
% 2. Discrete Fourier Transform
% 3. Time Difference
% 4. Dynamic Time Warping and Decorrelation
% 5. Vector Base Amplitude Panning
% 6. Vector Base Intensity Panning
%
% References
% [1] Georganti, E., Tsilfidis, A., Mourjopoulos, J. (2011). “Statistical 
%     Analysis of Binaural Room Impulse Re- sponses.” Audio Engineering Society 
%     Convention 130, Audio Engineering Society, pp. 1-7.
% [2] Kearney, G., Masterson, C., Adams, S., Boland, F. (2009). “Approximation 
%     of Binaural Room Impulse Responses.” IET Irish Signals and Systems 
%     Conference, pp. 1-6.

function s = Obj_IC(roomType,folder,method)

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

%% Actual IRs

% Transforming IRs into the frequency domain

Fx_int_act_L = zeros(size(IR_L));
Fx_int_act_R = zeros(size(IR_R));

for n = 1:size(IR_L,2)
    
    Fx_int_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_int_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
end


% IC calculation
act_IC = zeros(1,size(IR_L,2));

act_num = zeros(1,size(IR_L,2));
act_den= zeros(1,size(IR_L,2));

for c = 1:size(IR_L,2)
    
    act_num(:,c) =+ abs(compute_expected_value(Fx_int_act_L(:,c) .* conj(Fx_int_act_R(:,c))));
    
    act_den(:,c) =+ sqrt(compute_expected_value((Fx_int_act_L(:,c) .* conj(Fx_int_act_L(:,c))))...
                    .* (compute_expected_value(Fx_int_act_R(:,c) .* conj(Fx_int_act_R(:,c)))));
                
    act_IC(:,c) =+ act_num(:,c) ./ act_den(:,c);
    
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

% Transforming interpolated IRs into the frequency domain

Fx_int_linear_L = zeros(size(intp_linear_L));
Fx_int_linear_R = zeros(size(intp_linear_R));

for n = 1:size(IR_L,2)
    
    Fx_int_linear_L(:,n) =+ fft(intp_linear_L(:,n),size(intp_linear_L,1));
    Fx_int_linear_R(:,n) =+ fft(intp_linear_R(:,n),size(intp_linear_R,1));
    
end


% IC calculation
linear_IC = zeros(1,size(intp_linear_L,2));

linear_num = zeros(1,size(intp_linear_L,2));
linear_den= zeros(1,size(intp_linear_L,2));

for c = 1:size(intp_linear_L,2)
    
    linear_num(:,c) =+ abs(compute_expected_value(Fx_int_linear_L(:,c) .* conj(Fx_int_linear_R(:,c))));
    
    linear_den(:,c) =+ sqrt(compute_expected_value((Fx_int_linear_L(:,c) .* conj(Fx_int_linear_L(:,c))))...
                    .* (compute_expected_value(Fx_int_linear_R(:,c) .* conj(Fx_int_linear_R(:,c)))));
                
    linear_IC(:,c) =+ linear_num(:,c) ./ linear_den(:,c);
    
end

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

% Transforming interpolated IRs into the frequency domain

Fx_int_dft_L = zeros(size(intp_dft_L));
Fx_int_dft_R = zeros(size(intp_dft_R));

for n = 1:size(intp_dft_L,2)
    
    Fx_int_dft_L(:,n) =+ fft(intp_dft_L(:,n),size(intp_dft_L,1));
    Fx_int_dft_R(:,n) =+ fft(intp_dft_R(:,n),size(intp_dft_R,1));
    
end


% IC calculation
dft_IC = zeros(1,size(intp_dft_L,2));

dft_num = zeros(1,size(intp_dft_L,2));
dft_den= zeros(1,size(intp_dft_L,2));

for c = 1:size(intp_dft_L,2)
    
    dft_num(:,c) =+ abs(compute_expected_value(Fx_int_dft_L(:,c) .* conj(Fx_int_dft_R(:,c))));
    
    dft_den(:,c) =+ sqrt(compute_expected_value((Fx_int_dft_L(:,c) .* conj(Fx_int_dft_L(:,c))))...
                    .* (compute_expected_value(Fx_int_dft_R(:,c) .* conj(Fx_int_dft_R(:,c)))));
                
    dft_IC(:,c) =+ dft_num(:,c) ./ dft_den(:,c);
    
end

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

% Transforming interpolated IRs into the frequency domain

Fx_int_tdiff_L = zeros(size(intp_tdiff_L));
Fx_int_tdiff_R = zeros(size(intp_tdiff_R));

for n = 1:size(Fx_int_tdiff_L,2)
    
    Fx_int_tdiff_L(:,n) =+ fft(intp_tdiff_L(:,n),size(intp_tdiff_L,1));
    Fx_int_tdiff_R(:,n) =+ fft(intp_tdiff_R(:,n),size(intp_tdiff_R,1));
    
end


% IC calculation
tdiff_IC = zeros(1,size(intp_tdiff_L,2));

tdiff_num = zeros(1,size(intp_tdiff_L,2));
tdiff_den= zeros(1,size(intp_tdiff_L,2));

for c = 1:size(intp_tdiff_L,2)
    
    tdiff_num(:,c) =+ abs(compute_expected_value(Fx_int_tdiff_L(:,c) .* conj(Fx_int_tdiff_R(:,c))));
    
    tdiff_den(:,c) =+ sqrt(compute_expected_value((Fx_int_tdiff_L(:,c) .* conj(Fx_int_tdiff_L(:,c))))...
                    .* (compute_expected_value(Fx_int_tdiff_R(:,c) .* conj(Fx_int_tdiff_R(:,c)))));
                
    tdiff_IC(:,c) =+ tdiff_num(:,c) ./ tdiff_den(:,c);
    
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

% Transforming interpolated IRs into the frequency domain

Fx_int_dtw_L = zeros(size(intp_dtw_L));
Fx_int_dtw_R = zeros(size(intp_dtw_R));

for n = 1:size(Fx_int_dtw_L,2)
    
    Fx_int_dtw_L(:,n) =+ fft(intp_dtw_L(:,n),size(intp_dtw_L,1));
    Fx_int_dtw_R(:,n) =+ fft(intp_dtw_R(:,n),size(intp_dtw_R,1));
    
end


% IC calculation
dtw_IC = zeros(1,size(intp_dtw_L,2));

dtw_num = zeros(1,size(intp_dtw_L,2));
dtw_den= zeros(1,size(intp_dtw_L,2));

for c = 1:size(intp_dtw_L,2)
    
    dtw_num(:,c) =+ abs(compute_expected_value(Fx_int_dtw_L(:,c) .* conj(Fx_int_dtw_R(:,c))));
    
    dtw_den(:,c) =+ sqrt(compute_expected_value((Fx_int_dtw_L(:,c) .* conj(Fx_int_dtw_L(:,c))))...
                    .* (compute_expected_value(Fx_int_dtw_R(:,c) .* conj(Fx_int_dtw_R(:,c)))));
                
    dtw_IC(:,c) =+ dtw_num(:,c) ./ dtw_den(:,c);
    
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

% Transforming interpolated IRs into the frequency domain

Fx_int_vbap_L = zeros(size(intp_vbap_L));
Fx_int_vbap_R = zeros(size(intp_vbap_R));

for n = 1:size(Fx_int_vbap_L,2)
    
    Fx_int_vbap_L(:,n) =+ fft(intp_vbap_L(:,n),size(intp_vbap_L,1));
    Fx_int_vbap_R(:,n) =+ fft(intp_vbap_R(:,n),size(intp_vbap_R,1));
    
end


% IC calculation
vbap_IC = zeros(1,size(intp_vbap_L,2));

vbap_num = zeros(1,size(intp_vbap_L,2));
vbap_den= zeros(1,size(intp_vbap_L,2));

for c = 1:size(intp_vbap_L,2)
    
    vbap_num(:,c) =+ abs(compute_expected_value(Fx_int_vbap_L(:,c) .* conj(Fx_int_vbap_R(:,c))));
    
    vbap_den(:,c) =+ sqrt(compute_expected_value((Fx_int_vbap_L(:,c) .* conj(Fx_int_vbap_L(:,c))))...
                    .* (compute_expected_value(Fx_int_vbap_R(:,c) .* conj(Fx_int_vbap_R(:,c)))));
                
    vbap_IC(:,c) =+ vbap_num(:,c) ./ vbap_den(:,c);
    
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

% Transforming interpolated IRs into the frequency domain

Fx_int_vbip_L = zeros(size(intp_vbip_L));
Fx_int_vbip_R = zeros(size(intp_vbip_R));

for n = 1:size(Fx_int_vbip_L,2)
    
    Fx_int_vbip_L(:,n) =+ fft(intp_vbip_L(:,n),size(intp_vbip_L,1));
    Fx_int_vbip_R(:,n) =+ fft(intp_vbip_R(:,n),size(intp_vbip_R,1));
    
end


% IC calculation
vbip_IC = zeros(1,size(intp_vbip_L,2));

vbip_num = zeros(1,size(intp_vbip_L,2));
vbip_den= zeros(1,size(intp_vbip_L,2));

for c = 1:size(intp_vbip_L,2)
    
    vbip_num(:,c) =+ abs(compute_expected_value(Fx_int_vbip_L(:,c) .* conj(Fx_int_vbip_R(:,c))));
    
    vbip_den(:,c) =+ sqrt(compute_expected_value((Fx_int_vbip_L(:,c) .* conj(Fx_int_vbip_L(:,c))))...
                    .* (compute_expected_value(Fx_int_vbip_R(:,c) .* conj(Fx_int_vbip_R(:,c)))));
                
    vbip_IC(:,c) =+ vbip_num(:,c) ./ vbip_den(:,c);
    
end

%% Plots

figure;
%{
subplot(2,3,1);
plot(linear_IC,'b','LineWidth',3);
hold on;
plot(act_IC,'--');
title(strcat('Interaural Coherence - Linear',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('IC');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Linear','Dataset');
%}

subplot(2,2,1);
plot(dft_IC,'k','LineWidth',3);
hold on;
plot(act_IC,'--');
title(strcat('Interaural Coherence - DFT',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('IC');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('DFT','Dataset');

subplot(2,2,2);
plot(tdiff_IC,'r','LineWidth',3);
hold on;
plot(act_IC,'--');
title(strcat('Interaural Coherence - Time Diff',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('IC');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Time Diff','Dataset');

subplot(2,2,3);
plot(dtw_IC,'m','LineWidth',3);
hold on;
plot(act_IC,'--');
title(strcat('Interaural Coherence - DTW',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('IC');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('DTW','Dataset');

subplot(2,2,4);
plot(vbap_IC,'g','LineWidth',3);
hold on;
plot(act_IC,'--');
title(strcat('Interaural Coherence - VBAP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('IC');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('VBAP','Dataset');

%{
subplot(2,3,6);
plot(vbip_IC,'c','LineWidth',3);
hold on;
plot(act_IC,'--');
title(strcat('Interaural Coherence - VBIP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('IC');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
}%
legend('VBIP','Dataset');
%}

%% Calculating Statistics

% Measuring deviation of interpolated set from original set

% DFT
abs_error_dft = abs(act_IC - dft_IC);
mean_dft = mean(abs_error_dft);
std_dft = std(abs_error_dft);

% DTW
abs_error_dtw = abs(act_IC - dtw_IC);
mean_dtw = mean(abs_error_dtw);
std_dtw = std(abs_error_dtw);

% Time Difference
abs_error_tdiff = abs(act_IC - tdiff_IC);
mean_tdiff = mean(abs_error_tdiff);
std_tdiff = std(abs_error_tdiff);

% VBAP
abs_error_vbap = abs(act_IC - vbap_IC);
mean_vbap = mean(abs_error_vbap);
std_vbap = std(abs_error_vbap);

s = {strcat(num2str(method),'_',roomType),'mean','std'; 'dft',mean_dft,std_dft; ...
        'dtw',mean_dtw,std_dtw; 'tdiff',mean_tdiff,std_tdiff; 'vbap',mean_vbap,std_vbap};
       
end