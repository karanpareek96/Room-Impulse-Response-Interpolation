% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the Absolute Error of the IRs using
% the following interpolation methods:
% 1. Linear
% 2. Discrete Fourier Transform
% 3. Time Difference
% 4. Dynamic Time Warping and Decorrelation
% 5. Vector Base Amplitude Panning
% 6. Vector Base Intensity Panning
%
% References
% [1] De Sousa, G. H., Queiroz, M. (2009). “Two approaches for HRTF interpolation.” 
%     The 12th Brazilian Sym- posium on Computer Music (SBCM 2009), pp. 1-12.

function s = Obj_AE(roomType,folder,method)

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

% Initializing blank matrices
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

Fx_int_linear_L = zeros(size(intp_linear_L));
Fx_int_linear_R = zeros(size(intp_linear_R));

% Transformation into the frequency domain using the DFT function
for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
    Fx_int_linear_L(:,n) =+ fft(intp_linear_L(:,n),size(intp_linear_L,1));
    Fx_int_linear_R(:,n) =+ fft(intp_linear_R(:,n),size(intp_linear_R,1));
    
end

% Calculating the relative error
rel_error_linear_L = zeros(size(IR_L));
rel_error_linear_R = zeros(size(IR_R));

for k = 1:size(rel_error_linear_L,2)
    
    rel_error_linear_L(:,k) =+ abs(Fx_act_L(:,k) - Fx_int_linear_L(:,k)) ./ ...
                        abs(Fx_act_L(:,k));
                    
    rel_error_linear_R(:,k) =+ abs(Fx_act_R(:,k) - Fx_int_linear_R(:,k)) ./ ...
                        abs(Fx_act_R(:,k));
    
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

% Initializing blank matrices
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

Fx_int_dft_L = zeros(size(intp_dft_L));
Fx_int_dft_R = zeros(size(intp_dft_R));

% Transformation into the frequency domain using the DFT function
for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
    Fx_int_dft_L(:,n) =+ fft(intp_dft_L(:,n),size(intp_dft_L,1));
    Fx_int_dft_R(:,n) =+ fft(intp_dft_R(:,n),size(intp_dft_R,1));
    
end

% Calculating the relative error
rel_error_dft_L = zeros(size(IR_L));
rel_error_dft_R = zeros(size(IR_R));

for k = 1:size(rel_error_dft_L,2)
    
    rel_error_dft_L(:,k) =+ abs(Fx_act_L(:,k) - Fx_int_dft_L(:,k));
                    
    rel_error_dft_R(:,k) =+ abs(Fx_act_R(:,k) - Fx_int_dft_R(:,k));
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

% Initializing blank matrices
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

Fx_int_tdiff_L = zeros(size(intp_tdiff_L));
Fx_int_tdiff_R = zeros(size(intp_tdiff_R));

% Transformation into the frequency domain using the DFT function
for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
    Fx_int_tdiff_L(:,n) =+ fft(intp_tdiff_L(:,n),size(intp_tdiff_L,1));
    Fx_int_tdiff_R(:,n) =+ fft(intp_tdiff_R(:,n),size(intp_tdiff_R,1));
    
end

% Calculating the relative error
rel_error_tdiff_L = zeros(size(IR_L));
rel_error_tdiff_R = zeros(size(IR_R));

for k = 1:size(rel_error_tdiff_L,2)
    
    rel_error_tdiff_L(:,k) =+ abs(Fx_act_L(:,k) - Fx_int_tdiff_L(:,k));
    rel_error_tdiff_R(:,k) =+ abs(Fx_act_R(:,k) - Fx_int_tdiff_R(:,k));
    
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

% Initializing blank matrices
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

Fx_int_dtw_L = zeros(size(intp_dtw_L));
Fx_int_dtw_R = zeros(size(intp_dtw_R));

% Transformation into the frequency domain using the DFT function
for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
    Fx_int_dtw_L(:,n) =+ fft(intp_dtw_L(:,n),size(intp_dtw_L,1));
    Fx_int_dtw_R(:,n) =+ fft(intp_dtw_R(:,n),size(intp_dtw_R,1));
    
end

% Calculating the relative error
rel_error_dtw_L = zeros(size(IR_L));
rel_error_dtw_R = zeros(size(IR_R));

for k = 1:size(rel_error_dtw_L,2)
    
    rel_error_dtw_L(:,k) =+ abs(Fx_act_L(:,k) - Fx_int_dtw_L(:,k));
                    
    rel_error_dtw_R(:,k) =+ abs(Fx_act_R(:,k) - Fx_int_dtw_R(:,k));
    
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

% Initializing blank matrices
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

Fx_int_vbap_L = zeros(size(intp_vbap_L));
Fx_int_vbap_R = zeros(size(intp_vbap_R));

% Transformation into the frequency domain using the DFT function
for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
    Fx_int_vbap_L(:,n) =+ fft(intp_vbap_L(:,n),size(intp_vbap_L,1));
    Fx_int_vbap_R(:,n) =+ fft(intp_vbap_R(:,n),size(intp_vbap_R,1));
    
end

% Calculating the relative error
rel_error_vbap_L = zeros(size(IR_L));
rel_error_vbap_R = zeros(size(IR_R));

for k = 1:size(rel_error_vbap_L,2)
    
    rel_error_vbap_L(:,k) =+ abs(Fx_act_L(:,k) - Fx_int_vbap_L(:,k));
    rel_error_vbap_R(:,k) =+ abs(Fx_act_R(:,k) - Fx_int_vbap_R(:,k));
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

% Initializing blank matrices
Fx_act_L = zeros(size(IR_L));
Fx_act_R = zeros(size(IR_R));

Fx_int_vbip_L = zeros(size(intp_vbip_L));
Fx_int_vbip_R = zeros(size(intp_vbip_R));

% Transformation into the frequency domain using the DFT function
for n = 1:size(IR_L,2)
    
    Fx_act_L(:,n) =+ fft(IR_L(:,n),size(IR_L,1));
    Fx_act_R(:,n) =+ fft(IR_R(:,n),size(IR_R,1));
    
    Fx_int_vbip_L(:,n) =+ fft(intp_vbip_L(:,n),size(intp_vbip_L,1));
    Fx_int_vbip_R(:,n) =+ fft(intp_vbip_R(:,n),size(intp_vbip_R,1));
    
end

% Calculating the relative error
rel_error_vbip_L = zeros(size(IR_L));
rel_error_vbip_R = zeros(size(IR_R));

for k = 1:size(rel_error_vbip_L,2)
    
    rel_error_vbip_L(:,k) =+ abs(Fx_act_L(:,k) - Fx_int_vbip_L(:,k)) ./ ...
                        abs(Fx_act_L(:,k));
                    
    rel_error_vbip_R(:,k) =+ abs(Fx_act_R(:,k) - Fx_int_vbip_R(:,k)) ./ ...
                        abs(Fx_act_R(:,k));
    
end

%% Plots

figure;
%{
subplot(2,3,1);
plot(mean(rel_error_linear_L),'LineWidth',3);
hold on;
plot(mean(rel_error_linear_R),'LineWidth',3);
title(strcat('Absolute Error - Linear',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Absolute Error');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');
%}

subplot(2,2,1);
plot(mean(rel_error_dft_L),'LineWidth',3);
hold on;
plot(mean(rel_error_dft_R),'LineWidth',3);
title(strcat('Absolute Error - DFT',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Absolute Error');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

subplot(2,2,2);
plot(mean(rel_error_tdiff_L),'LineWidth',3);
hold on;
plot(mean(rel_error_tdiff_R),'LineWidth',3);
title(strcat('Absolute Error - Time Diff',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Absolute Error');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

subplot(2,2,3);
plot(mean(rel_error_dtw_L),'LineWidth',3);
hold on;
plot(mean(rel_error_dtw_R),'LineWidth',3);
title(strcat('Absolute Error - DTW',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Absolute Error');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

subplot(2,2,4);
plot(mean(rel_error_vbap_L),'LineWidth',3);
hold on;
plot(mean(rel_error_vbap_R),'LineWidth',3);
title(strcat('Absolute Error - VBAP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Absolute Error');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');

%{
subplot(2,3,6);
plot(mean(rel_error_vbip_L),'LineWidth',3);
hold on;
plot(mean(rel_error_vbip_R),'LineWidth',3);
title(strcat('Absolute Error - VBIP',' (', roomType,')'));
xlabel('Azimuth (deg)');
ylabel('Absolute Error');
xticks(angles_D(1):angles_D(end));
xticklabels(string(angles_D));
xtickangle(315);
legend('Left','Right');
%}

%% Calculating Statistics

% Measuring deviation of interpolated set from original set

% DFT
mean_dft_L = mean(mean(rel_error_dft_L));
std_dft_L = mean(std(rel_error_dft_L));
mean_dft_R = mean(mean(rel_error_dft_R));
std_dft_R = mean(std(rel_error_dft_R));

% DTW
mean_dtw_L = mean(mean(rel_error_dtw_L));
std_dtw_L = mean(std(rel_error_dtw_L));
mean_dtw_R = mean(mean(rel_error_dtw_R));
std_dtw_R = mean(std(rel_error_dtw_R));

% Time Difference
mean_tdiff_L = mean(mean(rel_error_tdiff_L));
std_tdiff_L = mean(std(rel_error_tdiff_L));
mean_tdiff_R = mean(mean(rel_error_tdiff_R));
std_tdiff_R = mean(std(rel_error_tdiff_R));

% VBAP
mean_vbap_L = mean(mean(rel_error_vbap_L));
std_vbap_L = mean(std(rel_error_vbap_L));
mean_vbap_R = mean(mean(rel_error_vbap_R));
std_vbap_R = mean(std(rel_error_vbap_R));

s = {strcat(num2str(method),'_',roomType),'mean(L)','std(L)','mean(R)','std(R)'; ...
        'dft',mean_dft_L,std_dft_L,mean_dft_R,std_dft_R; ...
        'dtw',mean_dtw_L,std_dtw_L,mean_dtw_R,std_dtw_R; ...
        'tdiff',mean_tdiff_L,std_tdiff_L,mean_tdiff_R,std_tdiff_R; ...
        'vbap',mean_vbap_L,std_vbap_L,mean_vbap_R,std_vbap_R};
    
end