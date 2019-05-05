% Name: Karan Pareek
% Student ID: kp2218
%
% This function performs Fast Colvolution on two signals, A & B. It does so
% by first zero padding the two signals to ensure that their lengths are
% equal, taking the FFT, engaging in element wise multiplication and
% finally taking the IFFT of the matrix to produce an output signal y_fast.
% NOTE : Only works for row matrices
%
% INPUTS : Two row arrays (A, B)
% OUTPUT : Fast Convolution Matrix (y_fast)

function y_fast = compute_fast_conv(A,B)

%% Initilaisation

% Converting stereo row matrices to mono
if size(A,1) > 1
    A = mean(A,1);
elseif size(B,1) > 1
    B = mean(B,1);
end

%% Main Function

% First, we define the length of the result vector (or the convoluted
% vector) by the following equation:
% convLen = length(A) + length(B) - 1;

% Zero padding the given signals A and B so that they are of equal length
pad_A = zeros(1,length(B) - 1);
pad_B = zeros(1,length(A) - 1);

% Joining the the original array with the row of zeros such that:
% length(A) = length(B) = convLen
A = [A,pad_A];
B = [B,pad_B];

% Taking the FFT of the given signals
Fx_A = fft(A);
Fx_B = fft(B);

% Undertaking element wise multiplication
Fx_C = Fx_A .* Fx_B;
% i.e. Fx_A(1) * Fx_B(1), Fx_A(2) * Fx_B(2) and so on...

% Taking the inverse FFT of the given matrix to obtain the output
y_fast = ifft(Fx_C);

end