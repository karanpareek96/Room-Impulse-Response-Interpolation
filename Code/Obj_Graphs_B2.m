%% Absolute Error (Left)

a = [0.33 1.19 1.03 0.86
0.41 1.48 1.30 1.32
0.36 1.58 1.28 1.31
0.49 2.00 1.87 1.85
0.87 3.66 3.32 3.20];

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

a = [0.31 1.25 1.11 0.90
0.39 1.42 1.20 1.37
0.33 1.26 1.09 1.23
0.33 1.43 1.22 1.36
0.32 1.32 1.15 1.29
];

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

a = [0.14 0.05 0.17 0.28
0.13 0.03 0.11 0.20
0.08 0.02 0.12 0.18
0.06 0.05 0.12 0.14
0.04 0.05 0.09 0.12
];

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

a = [4.99 5.19 5.50 7.93
5.83 3.45 5.03 5.91
5.68 6.80 8.22 8.50
3.87 4.00 8.75 5.13
3.17 3.17 8.35 4.01
];

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

a = [1.75 2.75 14.00 9.58
2.92 3.25 16.17 10.75
2.83 2.17 16.67 10.33
2.33 3.75 15.75 29.67
6.75 5.58 17.83 12.17
];

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

a = [25.25 -3.22 -2.07 1.28
25.30 -3.37 -1.59 -2.21
27.30 -5.85 -3.11 -3.51
27.43 -5.60 -4.62 -4.51
26.75 -6.39 -4.74 -3.91
];

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

a = [26.54 -4.49 -3.00 0.86
26.54 -2.55 -0.01 -2.38
27.13 -2.65 -0.70 -2.95
26.89 -5.81 -2.89 -5.23
27.26 -3.74 -1.67 -3.90
];

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