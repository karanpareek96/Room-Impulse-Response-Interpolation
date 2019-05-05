% Name: Karan Pareek
% Net ID: kp2218
%
% This function splits an input IR into the Early and Late reflections by
% approximating the dimensions of the room.
% 
% INPUT: Input signal (ir), Dimensions of the room (L,W,H)
% OUTPUT: Left early (early_L), Right ealy (early_R), 
%         Left late (late_L), Right late (late_R)
%
% % References
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

function [early_L,early_R,late_L,late_R] = Interp_Transition_Time(ir,L,W,H)

%% Initialization

if ischar(ir)
    % Reading impulse responses
    [x,~] = audioread(ir);
elseif ~ischar(ir)
    x = ir;
end
    

% Splitting the responses into 2 channels so that they can be processed
% separately and later saved as a stereo impulse response
xL = x(:,1);
xR = x(:,2);

% Here, we need to calculate some parameters to detemermine the point of
% transition from the direct and early reflections to the reverberated tail
surfaceArea = ((2*L*W) + (2*L*H) + (2*H*W));
volume = (L*W*H);
c = 340; % Speed of sound (given)
Oe = 4; % Reflection order (given)

t_ro = ((4*volume)/(c*surfaceArea))*(Oe+1); % Transition time
t_ro = round(t_ro * 44100); % Converting to samples for easy calculation

%% IRs

% Direct and Early
early_L = xL((1:t_ro),1);
early_R = xR((1:t_ro),1);

% Reverberation Tail
late_L = xL((t_ro + 1:length(xL)),1);
late_R = xR((t_ro + 1:length(xR)),1);

end