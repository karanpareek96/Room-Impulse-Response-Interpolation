% Name: Karan Pareek
% Net ID: kp2218
%
% This function imports all '.wav' files from the given folder and arranges
% them into two matrices, left and right. Each audio file in arranged
% column-wise.
%
% Note: Imports all angles.
% 
% INPUT: Folder name (folder)
% OUTPUT: Left matrix (IR_L), Right matrix (IR_R)

function [IR_L,IR_R] = import_IR_mat_data_1(folder)

files = dir(fullfile(folder,'*.wav'));
audio = cell(2,numel(files));

% Here, all the impulse responses from the folder are read into a cell
% matrix.

for k = 1:size(audio,2)
    
    filePath = fullfile(folder,files(k).name);
    audio{1,k} = audioread(filePath);
    
end

% Here, the IR is processed by splitting each channel into its own cell. 
% For each column (IR), first and second row are the left and right 
% channels respectively.

for k = 1:size(audio,2)
    
    ir = audio{1,k};
    
    audio{1,k} = ir(:,1);
    audio{2,k} = ir(:,2);
    
end

% Splitting the cell into matrices where each column represents an IR

IR_L = zeros(length(audio{1,1}),size(audio,2));
IR_R = zeros(length(audio{1,1}),size(audio,2));

for c = 1:size(audio,2)
    
    IR_L (:,c) =+ audio{1,c};
    IR_R (:,c) =+ audio{2,c};
    
end

end