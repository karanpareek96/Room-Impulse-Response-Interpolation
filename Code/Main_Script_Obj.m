% Name: Karan Pareek
% Net ID: kp2218
%
% This script calculates all the objective ratios for a given IR dataset
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
% Room 01     - 20 angles    - 0.170 secs    - (1,3)
% Room 04     - 20 angles    - 0.266 secs    - (1,3)
% Room 07A    - 18 angles    - 0.575 secs    - (1,2)
% Room 10     - 18 angles    - 0.823 secs    - (1,2)
% Room 16     - 20 angles    - 1.179 secs    - (1,3)

% Methods
% 1. All angles
% 2. 30 degree angles (18 files)
% 3. 30 degree angles (20 files)

%% Initialization

clear all;

% Importing the data
roomType = 'Room 01';
folder = './Rooms_Other/Room01';
method = 1;

%{
tic;
disp('Calculating t-Test ...');
s = Obj_tTest(roomType,folder,method);
toc;
%}

%% Objective Test

tic;
disp('Calculating AE ...');
s.AE = Obj_AE(roomType,folder,method);
toc;

tic;
disp('Calculating IC ...');
s.IC = Obj_IC(roomType,folder,method);
toc;

tic;
disp('Calculating ILD ...');
s.ILD = Obj_ILD(roomType,folder,method);
toc;

tic;
disp('Calculating ITD ...');
s.ITD = Obj_ITD(roomType,folder,method);
toc;

tic;
disp('Calculating SDR ...');
s.SDR = Obj_SDR(roomType,folder,method);
toc;