% Name: Karan Pareek
% Net ID: kp2218
%
% This function imports all '.wav' files from the given folder and arranges
% them into two matrices, left and right. Each audio file in arranged
% column-wise.
%
% Note: Import 30 degree angles (20 files)
% 
% INPUT: Folder name (folder)
% OUTPUT: Left matrix (IR_L), Right matrix (IR_R)

function [IR_L,IR_R] = import_IR_mat_data_3(folder)

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

IR_L = zeros(length(audio{1,1}),12);
IR_R = zeros(length(audio{1,1}),12);

%{
for c = 1:size(audio,2)/2
    
    IR_L (:,c) =+ audio{1,(2*c)};
    IR_R (:,c) =+ audio{2,(2*c)};
    
end
%}

% 0
IR_L (:,1) =+ audio{1,1}; IR_R (:,1) =+ audio{2,1};

% 30
IR_L (:,2) =+ audio{1,3}; IR_R (:,2) =+ audio{2,3};

% 60
IR_L (:,3) =+ audio{1,5}; IR_R (:,3) =+ audio{2,5};

% 90
IR_L (:,4) =+ audio{1,6}; IR_R (:,4) =+ audio{2,6};

% 120
IR_L (:,5) =+ audio{1,8}; IR_R (:,5) =+ audio{2,8};

% 150
IR_L (:,6) =+ audio{1,10}; IR_R (:,6) =+ audio{2,10};

% 180
IR_L (:,7) =+ audio{1,11}; IR_R (:,7) =+ audio{2,11};

% 210
IR_L (:,8) =+ audio{1,12}; IR_R (:,8) =+ audio{2,12};

% 240
IR_L (:,9) =+ audio{1,14}; IR_R (:,9) =+ audio{2,14};

% 270
IR_L (:,10) =+ audio{1,16}; IR_R (:,10) =+ audio{2,16};

% 300
IR_L (:,11) =+ audio{1,17}; IR_R (:,11) =+ audio{2,17};

% 330
IR_L (:,12) =+ audio{1,19}; IR_R (:,12) =+ audio{2,19};

end