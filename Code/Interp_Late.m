% Name: Karan Pareek
% Net ID: kp2218
%
% This function calculates the interpolation of impulse responses using the
% Decorrelation method. The output contains two matrices with the left and 
% right channel respectively. 
% 
% INPUT: Folder of IRs (folder), Dimensions of the room (L,W,H)
% OUTPUT: Left interpolated matrix (int_late_L), Right interpolated matrix (int_late_R)
%
% References
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

function [int_late_L,int_late_R] = Interp_Late(folder,L,W,H)

%% Reading the folder

% This function imports an entire dataset of IRs from a given directory and
% computes the cross correlation between each of them. This helps us derive
% the reverberated end of an interpolated IR. 

%folder = '/Users/karanpareek/Downloads/ASH-IR-Dataset-master/BRIRs/R01';
files = dir(fullfile(folder,'*.wav'));
audio = cell(2,numel(files));

% Here, all the impulse responses from the folder are read into a cell
% matrix.

for k = 1:size(audio,2)
    
    filePath = fullfile(folder,files(k).name);
    audio{1,k} = audioread(filePath);
    
end

% Here, the IR is processed by extracting out the late reflections and
% splitting each channel into its own cell. For each column (IR), first and
% second row are the left and right channels respectively.
for k = 1:size(audio,2)
    
    ir = audio{1,k};
    [~,~,ir_L,~] = Interp_Transition_Time(ir,L,W,H);
    [~,~,~,ir_R] = Interp_Transition_Time(ir,L,W,H);
    
    audio{1,k} = ir_L;
    audio{2,k} = ir_R;
    
end

%% Cross Correlation (Left)

corrCell_L = cell(numel(files),numel(files));

for a=1:numel(files)
    
    for b=1:numel(files)
        
        corrCell_L{a,b} = xcorr(audio{1,a},audio{1,b});
        val_a = sum((audio{1,a} .^ 2));
        val_b = sum((audio{1,b} .^ 2));
        val_c = sqrt(val_a * val_b);
        
        corrCell_L{a,b} = corrCell_L{a,b} / val_c;
        
    end
end

% Finding peak value of each correlated IR

max_val_L = zeros(numel(files),numel(files));
med_val_L = zeros(numel(files),numel(files));

for a = 1:size(corrCell_L,1)
    for b = 1:size(corrCell_L,2)
        
        max_val_L(a,b) =+ max(corrCell_L{a,b});
        med_val_L(a,b) =+ median(corrCell_L{a,b});

    end
end

%% Cross Correlation (Right)

corrCell_R = cell(numel(files),numel(files));

for a=1:numel(files)
    
    for b=1:numel(files)
        
        corrCell_R{a,b} = xcorr(audio{2,a},audio{2,b}); 
        
        val_d = sum((audio{2,a} .^ 2));
        val_e = sum((audio{2,b} .^ 2));
        val_f = sqrt(val_d * val_e);
        
        corrCell_R{a,b} = corrCell_R{a,b} / val_f;
        
    end
end

% Finding peak value of each correlated IR

max_val_R = zeros(numel(files),numel(files));
med_val_R = zeros(numel(files),numel(files));

for c = 1:size(corrCell_R,1)
    for d = 1:size(corrCell_R,2)
        
        max_val_R(c,d) =+ max(corrCell_R{c,d});
        med_val_R(c,d) =+ median(corrCell_R{c,d});
        
    end
end

%% Euclidean Distance (Left)

distCell_L = cell(numel(files),numel(files));

for a=1:numel(files)
   
    for b=1:numel(files)

        distCell_L{a,b} = sum((audio{1,a}-audio{1,b}).^2); 

    end
end

distMat_L = zeros(size(distCell_L));
blank_L = zeros(size(distCell_L));
distMat_L =+ cell2mat(distCell_L);

for k = 1:size(distMat_L,2)
    blank_L(:,k) =+ sort(distMat_L(:,k));
end

euc_Dist_L = min(min(blank_L(2:end,:)));
[x_L,~] = find(distMat_L == euc_Dist_L);


%% Euclidean Distance (Right)

distCell_R = cell(numel(files),numel(files));

for a=1:numel(files)
    
    for b=1:numel(files)

        distCell_R{a,b} = sum((audio{2,a}-audio{2,b}).^2); 

    end
end

distMat_R = zeros(size(distCell_R));
blank_R = zeros(size(distCell_R));
distMat_R =+ cell2mat(distCell_R);

for l = 1:size(distMat_R,2)
    blank_R(:,l) =+ sort(distMat_R(:,l));
end

euc_Dist_R = min(min(blank_R(2:end,:)));
[x_R,~] = find(distMat_R == euc_Dist_R);
% Here, x = [a,b] denote the IR that has min Euclidean dist
% Select a value of x where x = [a,a]


%% Selecting the appropriate IR

% Here, we select the IR that has minimum distance in the set (as
% calculated from above)

ideal_L = audio{1,x_L};
ideal_R = audio{2,x_R};
    
%% ERB Filtering
% NOTE: Cite the author!!!
% URL: https://engineering.purdue.edu/~malcolm/interval/1998-010/AuditoryToolboxTechReport.pdf
% URL: https://engineering.purdue.edu/~malcolm/interval/1998-010/

num_erb_filts = 40;
min_freq = 61;
fs = 44100;

% Filter Coefficients for the ERB filter
fcoefs = MakeERBFilters(fs,num_erb_filts,min_freq);

%{
% Example of the graph
y = ERBFilterBank([1 zeros(1,511)], fcoefs);
resp = 20*log10(abs(fft(y')));
freqScale = (0:511)/512*16000;
figure;
semilogx(freqScale(1:255),resp(1:255,:));
axis([100 16000 -60 0])
xlabel('Frequency (Hz)');
ylabel('Filter Response (dB)');
%}

% Left Channel
A_L = ERBFilterBank(ideal_L,fcoefs);
A_L = sum(A_L);
A_L = A_L';

% Right Channel
A_R = ERBFilterBank(ideal_R,fcoefs);
A_R = sum(A_R);
A_R = A_R';


% If the derived reverberation tail is too decorrelated after filtering, we
% can add sections of the original chosen IR to it. This deviation in the
% correlated value can be determined simply by calculating the absolute
% error value between the original tail and the derived tail. If the value
% of the error falls outside of the designed threshold, then the script
% will substitute that value with that of the original tail.

% Left
error_L = abs(ideal_L - A_L);
av_error_L = mean(error_L)*ones(size(error_L));

int_late_L = zeros(size(ideal_L));

for k = 1:length(error_L)
    
    if error_L(k) > av_error_L(k)
        
        int_late_L(k) =+ ideal_L(k);
        
    else
        
        int_late_L(k) =+ A_L(k);
        
    end
    
end

% Right
error_R = abs(ideal_R - A_R);
av_error_R = mean(error_R)*ones(size(error_R));

int_late_R = zeros(size(ideal_R));

for k = 1:length(error_R)
    
    if error_R(k) > av_error_R(k)
        
        int_late_R(k) =+ ideal_R(k);
        
    else
        
        int_late_R(k) =+ A_R(k);
        
    end
    
end

end