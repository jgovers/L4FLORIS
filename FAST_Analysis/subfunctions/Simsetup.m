% This script creates necessary workspace variables to run a Simulink model
% using the FAST dynamics and aerodynamic S-function block.  Before running
% a simulation, the character array, input_fast, must contain the FAST
% input file name, and the script Read_FAST_Input.m must run.
clc;
%clear all;

% Prompt the user for the input file name.
% [input_fast,PathName] = uigetfile('*.fst','Select FAST model');
input_fast = 'FASTTOOL.fst';
PathName = num2str(cd);

% Read FAST input file and set initial conditions
Read_FAST_Input

% Global variables needed for the azimuth_unwrap.m function
global az_prev counter;
az_prev = 0;
counter = 0;

% % Rated properties of the turbine
% TgRated = 43.09355;         % rated generator torque [kNm]
% Prated = 5000;              % rated power [kW]
% w_rated_rpm = 12.1;         % rated rotor speed [rpm]
% 
% % Low pass filter for High Speed Shaft speed
% f_cut = 0.25;               %Low pass filter cut-off frequency [Hz]
% w_cut = 2*pi*f_cut;         %Low pass filter cut-off frequency [rad/s]

% Listing the active DOFs
disp(sprintf('System has %d degree(s) of freedom:',noActiveDOF)); 
disp(activeDOFList);

clear PathName