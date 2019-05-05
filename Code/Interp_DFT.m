% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the interpolation of impulse responses using th
% Discrete Fourier Tranform method. The output contains two matrices with 
% the left and right channel respectively. 
% 
% INPUT: Folder name (folder)
% OUTPUT: Left interpolated matrix (IR_L), Right interpolated matrix (IR_R)
%
% Reference
% [1] Matsumoto, M., Yamanaka, S., Toyama, M., Nomura, H. (2004). “Effect 
%     of Arrival Time Correction on the Accuracy of Binaural Impulse Response 
%     Interpolation - Interpolation Methods of Binaural Response.” Journal of 
%     the Audio Engineering Society, 52(1/2), pp. 56-61.

function [int_L,int_R] = Interp_DFT(folder,method)

% Importing all the IRs

if method == 1
    
    [ir_L,ir_R] = import_IR_mat_data_1(folder);
    
elseif method == 2
    
    [ir_L,ir_R] = import_IR_mat_data_2(folder);
    
elseif method == 3
    
    [ir_L,ir_R] = import_IR_mat_data_3(folder);
    
end

%% Left

int_L = zeros(size(ir_L));

for m = 1:size(ir_L,2)
    
    %{
    A_mat: Actual IRs
    B_mat: FFT of A_mat

    C_mat: B_mat with zero insertion
    D_mat: IFFT of C_mat
    %}
    
    % Removing the mth column   
    A_mat_L = [ir_L(:,1:m-1),ir_L(:,m+1:end)];
    
    B_mat_L = zeros(size(A_mat_L));
    
    % Taking the DFT of each row
    for l = 1:size(A_mat_L,1)
        
        B_mat_L(l,:) =+ fft(A_mat_L(l,:),size(A_mat_L,2));
        
    end
    
    % Inserting the column of zeros
    col_L = zeros(size(int_L,1),1);
    C_mat_L = [B_mat_L(:,1:m-1),col_L,B_mat_L(:,m+1:end)];
    
    D_mat_L = zeros(size(C_mat_L));

    % Taking the inverse DFT of each row
    for k = 1:size(C_mat_L,1)

        D_mat_L(k,:) =+ real(ifft(C_mat_L(k,:),size(C_mat_L,2)));

    end
    
    % Adding the interpolated vector to a new matrix
    int_L(:,m) =+ D_mat_L(:,m);
    
end

%% Right

int_R = zeros(size(ir_R));

for m = 1:size(ir_R,2)
    
    %{
    A_mat: Actual IRs
    B_mat: FFT of A_mat

    C_mat: B_mat with zero insertion
    D_mat: IFFT of C_mat
    %}
    
    % Removing the mth column   
    A_mat_R = [ir_R(:,1:m-1),ir_R(:,m+1:end)];
    
    B_mat_R = zeros(size(A_mat_R));
    
    % Taking the DFT of each row
    for l = 1:size(A_mat_R,1)
        
        B_mat_R(l,:) =+ fft(A_mat_R(l,:),size(A_mat_R,2));
        
    end
    
    % Inserting the column of zeros
    col_R = zeros(size(int_R,1),1);
    C_mat_R = [B_mat_R(:,1:m-1),col_R,B_mat_R(:,m+1:end)];
    
    D_mat_R = zeros(size(C_mat_R));

    % Taking the inverse DFT of each row
    for k = 1:size(C_mat_R,1)

        D_mat_R(k,:) =+ real(ifft(C_mat_R(k,:),size(C_mat_R,2)));

    end
    
    % Adding the interpolated vector to a new matrix
    int_R(:,m) =+ D_mat_R(:,m);
    
end

% Note: Shifting all the IRs to the right by a step. (Change if the need be)
int_L = [int_L(:,end),int_L(:,1:(end-1))];
int_R = [int_R(:,end),int_R(:,1:(end-1))];

end