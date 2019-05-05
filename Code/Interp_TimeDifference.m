% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the interpolation of impulse responses using the
% Time Difference method. The output contains two matrices with the left 
% and right channel respectively. 
% 
% INPUT: Folder name (folder), Angles of the IRs (angles)
% OUTPUT: Left interpolated matrix (int_L), Right interpolated matrix (int_R)
%
% References
% [1] Matsumoto, M., Tohyama, M., & Yanagawa, H. (2003). “A Method of Interpolating 
%     Binaural Impulse Responses for Moving Sound Images.” Acoustical Science 
%     and Technology, 24(5), pp. 284-292.

function [int_L,int_R] = Interp_TimeDifference(folder,angles,method)

% Matsumoto et al. (2004) Pg 57
% Output is one cell with each row having all the IRs for a channel

% Importing all binaural IRs

if method == 1
    
    [ir_L,ir_R] = import_IR_mat_data_1(folder);
    
elseif method == 2
    
    [ir_L,ir_R] = import_IR_mat_data_2(folder);
    
elseif method == 3
    
    [ir_L,ir_R] = import_IR_mat_data_3(folder);
    
end

%% Time and Sample Rate

time_ir = zeros(size(ir_L)); % Time cell
% Exatrcting the sample rate

allFiles = dir(fullfile(folder,'*.wav'));
fs_filePath = fullfile(folder,allFiles(1).name);

[~,fs] = audioread(fs_filePath);

% We make just one time array matrix since the length of the left and right
% is the same
for i = 1:size(ir_L,2)
    
    time_ir(:,i) = 0:1/fs:(length(ir_L(:,i))-1)/fs;
    
end

%% Onset Detection using Spectral Flux

% NOTE!!!
% There are 2 options:
% 1. Improve on the novelty detection function
% 2. Choose the first non-zero number of the IR

% NOTE: Use it as an input for the function?
% Parameters for calculating the onset of each IR
win_size = 4;
hop_size = 1;
w_c = 75;
medfilt_len = 2;
offset = 0.1;
% How did I choose these parameters?!

onset_mat_L = zeros(1,size(ir_L,2));
onset_mat_R = zeros(1,size(ir_R,2));

for l = 1:size(ir_L,2)
    
    % Left Channel
    [n_t_i_L, t_nov_i_L, fs_nov_i_L] = ...
        compute_novelty_sf(ir_L(:,l), time_ir(:,l), fs, win_size, hop_size);
    [~, onset_t_i_L, ~, ~] = ...
        onsets_from_novelty(n_t_i_L, t_nov_i_L, fs_nov_i_L, w_c, medfilt_len, offset);
    onset_mat_L(:,l) =+ onset_t_i_L(1);
    
    % Right Channel
    [n_t_i_R, t_nov_i_R, fs_nov_i_R] = ...
        compute_novelty_sf(ir_R(:,l), time_ir(:,l), fs, win_size, hop_size);
    [~, onset_t_i_R, ~, ~] = ...
        onsets_from_novelty(n_t_i_R, t_nov_i_R, fs_nov_i_R, w_c, medfilt_len, offset);
    onset_mat_R(:,l) =+ onset_t_i_R(1);
    
end

d_ik_L = zeros(1,size(ir_L,2));
d_ik_R = zeros(1,size(ir_L,2));

for m = 1:size(ir_L,2)-2 % All minus 2 IRs (just like Linear Method)
    
    d_ik_L(:,m) =+ round(abs(onset_mat_L(:,m) - onset_mat_L(:,m+2)) * fs);
    
    d_ik_R(:,m) =+ round(abs(onset_mat_R(:,m) - onset_mat_R(:,m+2)) * fs);
    
end

%% Main Function

int_L = zeros(size(ir_L));
int_R = zeros(size(ir_R));

for k = 1:size(ir_L,2)-2
    
    % Just like the linear method, the for loop calculates the
    % interpolation values from 2:end-1.
    % The remaining two will be calculated outside the loop
    
    A = angles(1,k);
    B = angles(2,k);
    
    % Left Channel
    P_L = [ir_L(:,k)',zeros(1,d_ik_L(k))];
    Q_L = [zeros(1,d_ik_L(k)),ir_L(:,k+2)'];
    
    value_L = 1/(A+B) * (B*P_L + A*Q_L);
    int_L(:,k+1) =+ value_L(d_ik_L(k)+1:end);
    
    % Right Channel
    P_R = [ir_R(:,k)',zeros(1,d_ik_R(k))];
    Q_R = [zeros(1,d_ik_R(k)),ir_R(:,k+2)'];
    
    value_R = 1/(A+B) * (B*P_R + A*Q_R);
    int_R(:,k+1) =+ value_R(d_ik_R(k)+1:end);
                    
end

%% Interpolating the last IR
A_end = angles(1,size(angles,2)-1);
B_end = angles(2,size(angles,2)-1);

% Left Channel
P_end_L = [ir_L(:,end-1)',zeros(1,d_ik_L(end-1))];
Q_end_L = [zeros(1,d_ik_L(end-1)),ir_L(:,1)'];
    
value_end_L = 1/(A_end + B_end) * (B_end*P_end_L + A_end*Q_end_L);
int_L(:,end) = value_end_L(d_ik_L(end-1)+1:end);

% Right Channel
P_end_R = [ir_R(:,end-1)',zeros(1,d_ik_R(end-1))];
Q_end_R = [zeros(1,d_ik_R(end-1)),ir_R(:,1)'];
    
value_end_R = 1/(A_end + B_end) * (B_end*P_end_R + A_end*Q_end_R);
int_R(:,end) = value_end_R(d_ik_R(end-1)+1:end);

%% Interpolating the first IR

% Left Channel
A_start = angles(1,end);
B_start = angles(2,end);

P_start_L = [ir_L(:,end)',zeros(1,d_ik_L(end))];
Q_start_L = [zeros(1,d_ik_L(end)),ir_L(:,2)'];
    
value_start_L = 1/(A_start + B_start) * (B_start*P_start_L + A_start*Q_start_L);
int_L(:,1) = value_start_L(d_ik_L(end)+1:end);

% Right Channel
P_start_R = [ir_R(:,end)',zeros(1,d_ik_R(end))];
Q_start_R = [zeros(1,d_ik_R(end)),ir_R(:,2)'];
    
value_start_R = 1/(A_start + B_start) * (B_start*P_start_R + A_start*Q_start_R);
int_R(:,1) = value_start_R(d_ik_R(end)+1:end);

end