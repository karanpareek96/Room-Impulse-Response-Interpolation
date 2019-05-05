% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the interpolation of impulse responses using th
% Dynamic Time Warping and Decorrelation method. The output contains two 
% matrices with the left and right channel respectively. 
% 
% INPUT: Folder name (folder), Actual angles (angles_act), Interpolated
%        angles (angles_act), Dimensions of the room (L,W,H)
% OUTPUT: Left interpolated matrix (int_L), Right interpolated matrix (int_R)
%
% References
% [1] Kearney, G., Masterson, C., Adams, S., Boland, F. (2009). “Approximation
%     of Binaural Room Impulse Responses.” IET Irish Signals and Systems 
%     Conference, pp. 1-6.
% [2] Kearney, G., Masterson, C., Adams, S., Boland, F. (2009). “Dynamic 
%     Time Warping for Acoustic Response Interpolation: Possibilities and Limitations.” 
%     Signal Processing Conference, 2009 17th European, pp. 705-709.
% [3] Masterson, C., Kearney, G., Boland, F. (2009). “Acoustic Impulse Response 
%     Interpolation for Multichannel Systems using Dynamic Time Warping.” Audio 
%     Engineering Society Conference: 35th International Conference: Audio for Games, 
%     Audio Engineering Society, pp. 1-10.
% [4] Meesawat, K., Hammershøi, D. (2002). “An Investigation on the Transition 
%     from Early Reflections to a Reverberation Tail in a BRIR.” Proceedings of 
%     the 2002 International Conference on Auditory Display, Kyoto, Japan, pp. 1-5.

function [int_L,int_R] = Interp_DTW_DCR(folder,angles_act,angles_int,L,W,H,method)

%% Initialization

if method == 1

    audio = import_IR_cell_data_1(folder);
    
elseif method == 2

    audio = import_IR_cell_data_2(folder);
    
elseif method == 3

    audio = import_IR_cell_data_3(folder);
    
end

theta1 = angles_act(1,:);
theta2 = angles_act(2,:);

%% Early Part Interpolation

% Here, the IRs are read into the function where they are split into Early
% and Late reflections. The early reflections part is interpolated using
% Dynamic Time Warping.

int_early = {};

for k = 1:(size(audio,2)-2)
    
    [early_L,early_R] = Interp_Early(audio{1,k},audio{1,k+2},theta1(k),theta2(k),...
                        angles_int(k),L,W,H);
              
    int_early{1,k+1} = early_L;
    int_early{2,k+1} = early_R;
    
end

% Interpolating the last IR

[early_L_end,early_R_end] = Interp_Early(audio{1,end-1},audio{1,1},theta1(end-1),theta2(end),...
                        angles_int(end-1),L,W,H);
                    
int_early{1,size(audio,2)} = early_L_end;
int_early{2,size(audio,2)} = early_R_end;

% Interpolating the first IR

[early_L_start,early_R_start] = Interp_Early(audio{1,end},audio{1,2},theta1(end),theta2(end),...
                        angles_int(end),L,W,H);
                    
int_early{1,1} = early_L_start;
int_early{2,1} = early_R_start;

%% Late Part Interpolation

% To get the late reflections section, the entore database is processed
% and one IR is selected. This IR is first decorreleted then filtered using
% Equivalent Rectangular Bandwidth (ERB) filters.

[late_L,late_R] = Interp_Late(folder,L,W,H);

late_L = late_L';
late_R = late_R';

%% Concatenating the IRs

% Here, the function concatenates the early and late reflections that have
% been interpolated using the above functions

int_L = zeros(size(audio,2),length(audio{1,1}));
int_R = zeros(size(audio,2),length(audio{1,1}));

early_cell = {};

for k = 1:size(int_early,2)
    
    early_cell{1,k} = int_early{1,k}';
    int_L(k,:) =+ [early_cell{1,k},late_L];
    
    early_cell{2,k} = int_early{2,k}';
    int_R(k,:) =+ [early_cell{2,k},late_R];
    
end

int_L = int_L';
int_R = int_R';

end