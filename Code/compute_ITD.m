% Name: Karan Pareek
% Net ID: kp2218
%
% This function computes the Interaural Time Difference of a signal using
% the cross-correlation method.
% 
% INPUT: Input signal(x)
% OUTPUT: ITD of the signal (y)

function y = compute_ITD(x)

% Computing cross-correlation between the two channels
c = xcorr(x(:,1),x(:,2));

% Taking the max index value of the cross-correlation array
[~,i] = max(c);

% Computing ITD
y = length(x)/2 - (i - length(x)/2);

end