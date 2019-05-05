% Name: Karan Pareek
% Net ID: kp2218
%
% This function computes the inverse matrix corresponding to the angle pair
% and directional vectors.
% 
% INPUT: Desrired VBAP/VBIP angles (angles), Indexed angle pairs (pair_index)
% OUTPUT: Matrix of inversions (inverse_mat)
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

function inverse_mat = compute_inverse_matrix(angles,pair_index)

% Since this function focuses on computing the matrix of inversions for 2D
% VBAP and VBIP applications, the dimension used as part of the calculation
% is 2.
dimension = 2;

% Tranposing the angle array
angles = angles';

% Tranforming the input angles from degrees to radians
angles_rad = angles * (pi/180);

% In order to produce a gain vector with constant gain, the following
% condition must be true:
% (g1^2 + g2^2) = c (constant)
% Here, c = 1

% Here, the angle (in radians) is converted back to cartesian coordinates
% such that the first column represents the angle (theta) and the second
% column represents the unit vector (rho).
[const_gain(:,1),const_gain(:,2)] = pol2cart(angles_rad,1);

% Defining the inverse matrix
inverse_mat = zeros(size(pair_index,1), 2*dimension);

for n = 1:size(pair_index,1)
    
    % Taking pairs of two from each column
    temp = const_gain(pair_index(n,:),:);
    
    % Calculating the inverse of the selected matrix
    temp_inv = inv(temp);
    
    % Arranging the inverse into a column vector
    temp_inv = temp_inv(:);
    
    % Adding the inverse sub-matrix to the main inverse matrix
    inverse_mat(n,:) =+ temp_inv;
    
end

end