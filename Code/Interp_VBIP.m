% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the interpolation of impulse responses using the
% Vector Base Intensity Panning (VBIP) method. The output contains two 
% matrices with the left and right channel respectively. 
% 
% INPUT: Folder name (folder), Angles of the IRs (angles)
% OUTPUT: Left interpolated matrix (int_L), Right interpolated matrix (int_R)
%
% Reference
% [1] Pulkki, V. (1997). “Virtual Sound Source Positioning using Vector Base 
%     Amplitude Panning.” Journal of the Audio Engineering Society, 45(6), 
%     pp. 456-466.
% [2] Pulkki, V. (2001). “Spatial Sound Generation and Perception by Amplitude 
%     Panning techniques.” PhD Thesis, Helsinki University of Technology. 
%     Espoo, Finland.
% [3] Pulkki, V. (1999). "Uniform Spreading of Amplitude Panned Virtual Sources." 
%     IEEE Workshop on Applications of Signal Processing to Audio and Acoustics. 
%     New Paltz, New York, pp. 187-190.

function [int_L,int_R] = Interp_VBIP(folder,angles,method)

%% Initialization

% Importing all binaural IRs
if method == 1
    
    [ir_L,ir_R] = import_IR_mat_data_1(folder);
    
elseif method == 2
    
    [ir_L,ir_R] = import_IR_mat_data_2(folder);
    
elseif method == 3
    
    [ir_L,ir_R] = import_IR_mat_data_3(folder);
    
end

% Here, we're calculating the gains for all angles (0-359)
complete_dir = (0:359)';

% To compute the VBIP gains and the interpolated IRs, this function takes
% all the input angles and splits it into two groups, each with alternating
% angles. This allows the function to compute each alternate angle with a
% higher degree of efficiency

angles_A = angles(1:2:end);
angles_B = angles(2:2:end);

% Alternatively, the IR database is also split into two parts.
% Left Channel
ir_L_A = ir_L(:,1:2:end);
ir_L_B = ir_L(:,2:2:end);

% Right Channel
ir_R_A = ir_R(:,1:2:end);
ir_R_B = ir_R(:,2:2:end);

% Creating blank interpolation matrices
int_L = zeros(size(ir_L));
int_R = zeros(size(ir_R));

%% Part A

% Computing the angle pairs
angle_pairs_A = compute_speaker_pairs(angles_A);

% Computing the inverse matrix
inv_mat_A = compute_inverse_matrix(angles_A, angle_pairs_A);

% Computing the VBIP gains
vbip_A = vbip(complete_dir, angle_pairs_A, inv_mat_A);

% Now, the row that represents the required angle is multiplied with each
% IR to determine the interpolated IR.

for n = 1:length(angles_B)
    
    % Left channel
    x = repmat((vbip_A(angles_B(n),:)),size(int_L,1),1);
    blank_mat_L_A = x .* ir_L_A;
    blank_vec_L_A = sum(blank_mat_L_A,2);
    int_L(:,2*n) =+ blank_vec_L_A;
    
    % Right channel
    y = repmat((vbip_A(angles_B(n),:)),size(int_R,1),1);
    blank_mat_R_A = y .* ir_R_A;
    blank_vec_R_A = sum(blank_mat_R_A,2);
    int_R(:,2*n) =+ blank_vec_R_A;
    
end

%% Part B

% Computing the angle pairs
angle_pairs_B = compute_speaker_pairs(angles_B);

% Computing the inverse matrix
inv_mat_B = compute_inverse_matrix(angles_B, angle_pairs_B);

% Computing the VBIP gains
vbip_B = vbip(complete_dir, angle_pairs_B, inv_mat_B);

% Now, the row that represents the required angle is multiplied with each
% IR to determine the interpolated IR.

for n = 1:length(angles_A)
    
    % Left channel
    x = repmat((vbip_B(angles_B(n),:)),size(int_L,1),1);
    blank_mat_L_B = x .* ir_L_B;
    blank_vec_L_B = sum(blank_mat_L_B,2);
    int_L(:,(2*n)-1) =+ blank_vec_L_B;
    
    % Right channel
    y = repmat((vbip_B(angles_B(n),:)),size(int_R,1),1);
    blank_mat_R_B = y .* ir_R_B;
    blank_vec_R_B = sum(blank_mat_R_B,2);
    int_R(:,(2*n)-1) =+ blank_vec_R_B;
    
end

end