% Name: Karan Pareek
% Net ID: kp2218
%
% This function returns the matrices of angles required to carry out
% interpolation and objective analysis, given the name of the room.
%
% Note: Import 30 degree angles (20 files)
% 
% INPUT: Room name (name)
% OUTPUT: Type 1 matrix (angles_A), Type 2 matrix (angles_B), 
%         Type 3 matrix (angles_C), Type 4 matrix (angles_D)

function [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_3(roomType)

%% Room Types with angles

if strcmp(roomType,'Room 01')
    angles = 0:30:330;
    L = 5;
    W = 5.5;
    H = 3;

elseif strcmp(roomType,'Room 02')
    angles = 0:30:330;
    L = 6.85;
    W = 5.48;
    H = 2.47;
  
elseif strcmp(roomType,'Room 03')
    angles = 0:30:330;
    L = 5.8;
    W = 6.6;
    H = 2.7;
    
elseif strcmp(roomType,'Room 04')
    angles = 0:30:330;
    L = 7.26;
    W = 8.26;
    H = 2.9;
    
elseif strcmp(roomType,'Room 05A')
    angles = 0:30:330;
    L = 10;
    W = 9;
    H = 3;
 
elseif strcmp(roomType,'Room 05B')
    angles = 0:30:330;
    L = 5;
    W = 5.75;
    H = 3;
    
elseif strcmp(roomType,'Room 06A')
    angles = 0:30:330;
    L = 5;
    W = 5;
    H = 2.5;
    
elseif strcmp(roomType,'Room 06B')
    angles = 0:30:330;
    L = 5;
    W = 5;
    H = 2.5;
    
elseif strcmp(roomType,'Room 07A')
    angles = 0:30:330;
    L = 10.31;
    W = 5.76;
    H = 3.10;
    
elseif strcmp(roomType,'Room 07B')
    angles = 0:30:330;
    L = 5;
    W = 5;
    H = 2.5;
    
elseif strcmp(roomType,'Room 10')
    angles = 0:30:330;
    L = 10;
    W = 9;
    H = 4;
    
elseif strcmp(roomType,'Room 16')
    angles = 0:30:330;
    L = 30.28;
    W = 16.52;
    H = 11.16;
    
elseif strcmp(roomType,'Room X')
    [~, ~, ~, angles, ~] = compute_room_selector_1(roomType);
    angles = angles(2:2:end);
    L = 4;
    W = 3;
    H = 3;
    
end

%% Main Function

% First matrix
angles_A(1,:) = [diff(angles),(360-angles(end))];
angles_A(2,:) = [angles_A(1,2:end),angles_A(1)];

% Second matrix
angles_B(1,:) = angles;
angles_B(2,:) = [angles(3:end),360,angles(2)];

% Third matrix
angles_C = [angles(2:end),360];

% Fourth matrix
angles_D = angles;

% Dimension matrix
dimensions = [L,W,H];

end