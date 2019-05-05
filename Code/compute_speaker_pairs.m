% Name: Karan Pareek
% Net ID: kp2218
%
% This function computes the pair of speakers based on the input angles. It
% sorts the pairs based on index numbers.
% 
% INPUT: Desrired VBAP/VBIP angles (angles)
% OUTPUT: Indexed angle pairs (pair_index)
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

function pair_index = compute_speaker_pairs(angles)

% Sorting the input angles into asceding order and extrating their indices
[~, indices] = sort(angles);
% Adding the first index value towards the end
indices(end + 1) = indices(1);

% Creating the index pair matrix
pair_index = zeros((length(indices) - 1),2);

pair_index(:,1) =+ indices(1:length(angles));
pair_index(:,2) =+ indices(2:end);

end