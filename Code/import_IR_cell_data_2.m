% Name: Karan Pareek
% Net ID: kp2218
%
% This function imports all '.wav' files from the given folder and arranges
% them into cell arrays.
%
% Note: Import 30 degree angles (18 files)
% 
% INPUT: Folder name (folder)
% OUTPUT: Cell array (audio)

function audioCell = import_IR_cell_data_2(folder)

files = dir(fullfile(folder,'*.wav'));
audio = cell(2,numel(files));

% Here, all the impulse responses from the folder are read into a cell
% matrix.

for k = 1:size(audio,2)
    
    filePath = fullfile(folder,files(k).name);
    audio{1,k} = audioread(filePath);
    
end

%{
for n = 1:size(audio,2)/2
    
    audioCell{1,n} = audio{1,(2*n)};
    audioCell{2,n} = audio{2,(2*n)};
    
end
%}

% Importing IRs such that the angles are available every 30 degrees
% Since we know that there will 12 out of the 18 IRs that should be
% included, the code here has to be hard coded

% 0
audioStore{1,1} = audio{1,1}; audioStore{2,1} = audio{2,1};

% 30
audioStore{1,2} = audio{1,2}; audioStore{2,2} = audio{2,2};

% 60
audioStore{1,3} = audio{1,4}; audioStore{2,3} = audio{2,4};

% 90
audioStore{1,4} = audio{1,5}; audioStore{2,4} = audio{2,5};

% 120
audioStore{1,5} = audio{1,7}; audioStore{2,5} = audio{2,7};

% 150
audioStore{1,6} = audio{1,9}; audioStore{2,6} = audio{2,9};

% 180
audioStore{1,7} = audio{1,10}; audioStore{2,7} = audio{2,10};

% 210
audioStore{1,8} = audio{1,11}; audioStore{2,8} = audio{2,11};

% 240
audioStore{1,9} = audio{1,13}; audioStore{2,9} = audio{2,13};

% 270
audioStore{1,10} = audio{1,15}; audioStore{2,10} = audio{2,15};

% 300
audioStore{1,11} = audio{1,16}; audioStore{2,11} = audio{2,16};

% 330
audioStore{1,12} = audio{1,18}; audioStore{2,12} = audio{2,18};

audioCell = audioStore;

end