% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the expected value of an input array, where
% (1/p) is the probability of the occurance of each event.
% 
% INPUT: Array (x)
% OUTPUT: Expected value (E[x])

function y = compute_expected_value(x)

% Probability of each event
p = 1/length(x);

% Multiplying the event with each probability
seq = x * p;

% Summing the array to get the expected value E[x]
y = sum(seq);

end