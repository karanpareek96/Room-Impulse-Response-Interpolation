% Name: Karan Pareek
% Net ID: kp2218
%
% This function imports all '.wav' files from the given folder and arranges
% them into cell arrays.
%
% Note: Imports all angles.
% 
% INPUT: Folder name (folder)
% OUTPUT: Cell array (audio)

function audio = import_IR_cell_data_1(folder)

files = dir(fullfile(folder,'*.wav'));
audio = cell(2,numel(files));

% Here, all the impulse responses from the folder are read into a cell
% matrix.

for k = 1:size(audio,2)
    
    filePath = fullfile(folder,files(k).name);
    audio{1,k} = audioread(filePath);
    
end

end