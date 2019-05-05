%% Absolute Error (Left)

a = [0.20,1.09,0.87,0.80;
0.25,1.33,1.03,0.99;
0.25,1.34,1.00,1.01;
0.32,1.77,1.68,1.46;
0.55,3.30,2.84,2.72];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Absolute Error (Left)');
xlabel('Reverberation Time (secs)');
ylabel('Mean AE (units)');
ylim([0,4]);
grid on;

%% Absolute Error (Right)

a = [0.22 1.12 0.85 0.95;
0.27 1.27 1.11 1.08
0.25 1.23 1.02 1.08
0.31 1.81 1.68 1.44
0.23 1.27 0.99 1.09];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Absolute Error (Right)');
xlabel('Reverberation Time (secs)');
ylabel('Mean AE (units)');
ylim([0,4]);
grid on;

%% Interaural Coherence

a = [0.08 0.04 0.12 0.13
0.06 0.04 0.08 0.08
0.07 0.03 0.11 0.09
0.05 0.03 0.08 0.09
0.02 0.04 0.08 0.05];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Interaural Coherence Deviation');
xlabel('Reverberation Time (secs)');
ylabel('Mean IC Deviation (units)');
ylim([0,0.3]);
grid on;

%% Interaural Level Difference

a = [3.00 3.73 3.37 7.42
3.24 3.49 2.79 3.82
4.21 3.88 4.46 5.04
2.12 3.29 3.54 4.13
1.29 1.76 2.71 3.34];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Interaural Level Difference Deviation');
xlabel('Reverberation Time (secs)');
ylabel('Mean ILD Deviation (dB)');
ylim([0,9]);
grid on;

%% Interaural Time Difference

a = [0.95 2.30 6.20 4.70
1.30 2.20 6.35 4.95
1.44 1.78 7.72 5.28
1.33 2.22 6.00 19.17
2.25 3.55 8.80 6.45];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Interaural Time Difference Deviation');
xlabel('Reverberation Time (secs)');
ylabel('Mean ITD Deviation (samples)');
ylim([0,30]);
grid on;

%% Signal-to-Distortion Ratio (Left)

a = [34.57 -0.96 2.16 3.72
36.13 -0.86 2.95 3.79
36.13 -0.86 2.95 3.79
32.48 -5.45 -4.67 -2.00
34.52 -4.77 -2.27 -1.05];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Signal-to-Distortion Ratio (Left)');
xlabel('Reverberation Time (secs)');
ylabel('Mean SDR (dB)');
ylim([-10,40]);
grid on;

%% Signal-to-Distortion Ratio (Right)

a = [34.75 -1.87 2.39 0.27
35.67 -0.13 2.02 2.76
33.93 -2.30 0.68 -0.55
32.32 -6.21 -5.09 -1.73
35.09 -3.12 1.28 -0.18];

b = categorical({'0.170 (R1)','0.266 (R2)','0.575 (R3)',...
                 '0.823 (R4)','1.179 (R5)'});
figure;
bar(b,a);
set(legend('DFT','DTW','Time Diff','VBAP'),'Location','BestOutside');
legend('boxoff');
title('Mean Signal-to-Distortion Ratio (Right)');
xlabel('Reverberation Time (secs)');
ylabel('Mean SDR (dB)');
ylim([-10,40]);
grid on;