%% Point Sound Source

a = [0.80 0.71 0.63 0.66;
    0.57 0.68 0.23 0.41;
    0.705 0.741 0.518 0.643];

b = categorical({'DFT','DTW','Time Diff','VBAP'});
figure;
bar(b,a');
set(legend('Batch 1', 'Batch 2', 'Both Batches'),'Location','BestOutside');
legend('boxoff');
title('Interpolation Similarity Score (Point Sound Source)');
xlabel('Interpolation Method');
ylabel('Similarity Score (units)');
ylim([0,1]);
grid on;

%% Timbre Test

a = [0.71 0.64 0.70 0.73;
    0.52 0.73 0.57 0.55;
    0.683 0.701 0.692 0.696];

b = categorical({'DFT','DTW','Time Diff','VBAP'});
figure;
bar(b,a');
set(legend('Batch 1', 'Batch 2', 'Both Batches'),'Location','BestOutside');
legend('boxoff');
title('Interpolation Similarity Score (Timbre Test)');
xlabel('Interpolation Method');
ylabel('Similarity Score (units)');
ylim([0,1]);
grid on;

%% Smoothness Test (Batch 1)

a = [5 23;
     10, 18;
     6, 22;
     9, 19];

b = categorical({'DFT','DTW','Time Diff','VBAP'});
figure;
bar(b,a);
set(legend('Less Smooth', 'Others'),'Location','BestOutside');
legend('boxoff');
title('Smoothness Votes (Batch 1)');
xlabel('Interpolation Methods');
ylabel('Number of Votes');
ylim([0,28]);
grid on;

%% Smoothness Test (Batch 2)

a = [8 20;
     6, 22;
     10, 18;
     3, 25];

b = categorical({'DFT','DTW','Time Diff','VBAP'});
figure;
bar(b,a);
set(legend('Less Smooth', 'Others'),'Location','BestOutside');
legend('boxoff');
title('Smoothness Votes (Batch 2)');
xlabel('Interpolation Methods');
ylabel('Number of Votes');
ylim([0,28]);
grid on;

%% Point Test (Room Comparison)

a = [0.79 0.68 0.46 0.63;
    0.55 0.75 0.39 0.55];

b = categorical({'DFT','DTW','Time Diff','VBAP'});
figure;
bar(b,a');
set(legend('Room 2', 'Room 5'),'Location','BestOutside');
legend('boxoff');
title('Interpolation Similarity Score (Point Sound Source)');
xlabel('Interpolation Method');
ylabel('Similarity Score (units)');
ylim([0,1]);
grid on;

%% Timbre Test (Room Comparison)

a = [0.70 0.69 0.68 0.73;
    0.54 0.67 0.62 0.54];

b = categorical({'DFT','DTW','Time Diff','VBAP'});
figure;
bar(b,a');
set(legend('Room 2', 'Room 5'),'Location','BestOutside');
legend('boxoff');
title('Interpolation Similarity Score (Timbre Test)');
xlabel('Interpolation Method');
ylabel('Similarity Score (units)');
ylim([0,1]);
grid on;