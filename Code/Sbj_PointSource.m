% Name: Karan Pareek
% Net ID: kp2218
%
% This function computes the point source audio file for a given
% interpolation method.
%
% INPUTS: Folder extension (folder), Filename extension (filename),
% Interpolation method (intpMethod), Type of room (roomType), Generation
% method (method)
%
% Interpolation Methods
% 1. Actual
% 2. Linear
% 3. VBAP
% 4. VBIP
% 5. DFT
% 6. Time Diff
% 7. DTW

function [] = Sbj_PointSource(folder,filename,intpMethod,roomType,method,writeTog)

%% Initialization

warning off; % Turn this OFF!!!

if method == 1
    [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_1(roomType);
elseif method == 2
    [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_2(roomType);
elseif method == 3
    [angles_A,angles_B,angles_C,angles_D,dimensions] = compute_room_selector_3(roomType);
end

%% Imporing IRs

if strcmp(intpMethod,'Actual')
    
    if method == 1
        % Actual
        [ir_L,ir_R] = import_IR_mat_data_1(folder);
        ir_L = ir_L';
        ir_R = ir_R';
        
    elseif method == 2
        % Actual
        [ir_L,ir_R] = import_IR_mat_data_2(folder);
        ir_L = ir_L';
        ir_R = ir_R';
        
    elseif method == 3
        % Actual
        [ir_L,ir_R] = import_IR_mat_data_3(folder);
        ir_L = ir_L';
        ir_R = ir_R';
        
    end
    
elseif strcmp(intpMethod,'Linear')
    
    % Linear
    [ir_L,ir_R] = Interp_Linear(folder,angles_A,method);
    ir_L = ir_L';
    ir_R = ir_R';

elseif strcmp(intpMethod,'VBAP')
    
    % VBAP
    [ir_L,ir_R] = Interp_VBAP(folder,angles_D,method);
    ir_L = ir_L';
    ir_R = ir_R';
    
elseif strcmp(intpMethod,'VBIP')
    
    % VBAP
    [ir_L,ir_R] = Interp_VBIP(folder,angles_D,method);
    ir_L = ir_L';
    ir_R = ir_R';
    
elseif strcmp(intpMethod,'DFT')
    
    % DFT
    [ir_L,ir_R] = Interp_DFT(folder,method);
    ir_L = ir_L';
    ir_R = ir_R';
    
elseif strcmp(intpMethod,'TimeDiff')
        
    % Time Difference
    [ir_L,ir_R] = Interp_TimeDifference(folder,angles_A,method);
    ir_L = ir_L';
    ir_R = ir_R';
    
elseif strcmp(intpMethod,'DTW')
    
    % DTW
    L = dimensions(1);
    W = dimensions(2);
    H = dimensions(3);
    
    [ir_L,ir_R] = Interp_DTW_DCR(folder,angles_B,angles_C,L,W,H,method);
    ir_L = ir_L';
    ir_R = ir_R';
    
end

% Audio file
[x,fs] = audioread(filename);
if size(x,2) > 1
    x = mean(x,2);
end
x = x';

%% Convolution

ir_conv_L = zeros(size(ir_L,1),(length(x)+size(ir_L,2)-1));
ir_conv_R = zeros(size(ir_R,1),(length(x)+size(ir_R,2)-1));

for n = 1:size(ir_conv_L,1)
    
    ir_conv_L(n,:) =+ compute_fast_conv(x,ir_L(n,:));
    ir_conv_R(n,:) =+ compute_fast_conv(x,ir_R(n,:));
    
end

%% Compile

for k = 1:size(ir_conv_L,1)
    
    leftChannel = ir_conv_L(k,:)';
    rightChannel = ir_conv_R(k,:)';
    
    maxLeft = max(abs(leftChannel));
    maxRight = max(abs(rightChannel));

        if maxLeft > maxRight
            leftChannel = leftChannel/maxLeft;
            leftChannel = 0.9 * leftChannel;
            rightChannel = rightChannel/maxLeft;
            rightChannel = 0.9 * rightChannel;

        elseif maxRight > maxLeft
            leftChannel = leftChannel/maxRight;
            leftChannel = 0.9 * leftChannel;
            rightChannel = rightChannel/maxRight;
            rightChannel = 0.9 * rightChannel;

        end

    outputFile = [leftChannel,rightChannel];
    %soundsc(outputFile,fs);
    
    audioFilename = strcat('Sbj_Point_',roomType(1:4),roomType(6:end),'_Batch',num2str(method),'_',...
                       intpMethod,'_',num2str(angles_D(k)),'.wav');
    
    if strcmp(writeTog,'On')
        audiowrite(audioFilename,outputFile,fs);
    end
    
end