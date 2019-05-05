% Name: Karan Pareek
% Net ID: kp2218
%
% This script calculates all the subjective files for a given IR dataset
% using the following interpolation methods:
% 1. Discrete Fourier Transform (DFT)
% 2. Time Difference (TimeDiff)
% 3. Dynamic Time Warping and Decorrelation (DTW)
% 4. Vector Base Amplitude Panning (VBAP)
%
% INPUTS: Folder extension (folder), Filename extension (filename),
% Interpolation method (intpMethod), Type of room (roomType), Generation
% method (method)

% Room Information
% Room 01     - 20 angles    - 0.170 secs
% Room 02     - 20 angles    - 0.232 secs
% Room 03     - 20 angles    - 0.261 secs
% Room 04     - 20 angles    - 0.266 secs
% Room 05A    - 20 angles    - 0.369 secs
% Room 05B    - 20 angles    - 0.949 secs
% Room 06A    - 20 angles    - 0.474 secs
% Room 16     - 20 angles    - 1.179 secs

% Room 07A    - 18 angles    - 0.575 secs
% Room 10     - 18 angles    - 0.823 secs

% Methods
% 1. All angles
% 2. 30 degree angles (18 files)
% 3. 30 degree angles (20 files)

%% Initialization

% Importing the data
folder = './Rooms_Other/Room04';
filename = './Sbj_Audio(Test)/Moving/01.wav';
intpMethod = 'Actual';
roomType = 'Room 04';
method = 1;

pattern = 'A';
soundTog = 'Off';
writeTog = 'On';

%% Moving Sound Source Test

tic;
disp('Calculating Moving Sound Source ...');
Sbj_MovingSource(folder,filename,intpMethod,roomType,method,pattern,soundTog,writeTog);
toc;

%% Initialization

folder = './Rooms_Other/Room16';
filename = './Sbj_Audio(Test)/Point/08.wav';
intpMethod = 'Actual';
roomType = 'Room 16';
method = 1;

writeTog = 'On';

%% Point Sound Source Test

tic;
disp('Calculating Point Sound Source ...');
Sbj_PointSource(folder,filename,intpMethod,roomType,method,writeTog);
toc;