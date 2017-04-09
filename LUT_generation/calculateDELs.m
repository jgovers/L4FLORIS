%% Just a placeholder file to run from main directory
clear all; close all; clc;
addpath bin

% Setup inflow settings
inflowSetName          = 'C2C_only';
inputData.sourceFolder = ['inflowProfiles\' inflowSetName];

% Specify correct settings and load workspace
WS          = load([inputData.sourceFolder '\workspace.mat']);
T           = WS.inputData.T;  % simulation time in seconds
dt          = WS.inputData.dt; % sampling time in seconds

% Import relevant libraries and files for FAST
load('FAST_module\Controller_parameters');   % Load FAST settings
addpath(genpath('FAST_module\Source'))       %Load Path needed for execution of this code
addpath(genpath('FAST_module\slprj'))        %Load Path needed for execution of this code
addpath(genpath('FAST_module\subfunctions')) %Load Path needed for execution of this code
addpath(genpath('FAST_module\Data'))         %Load Path needed for execution of this code
addpath(genpath('FAST_module\Outputs'))      %Load Path needed for execution of this code

% Evaluate DELs
[matDELs,~] = nested_calculateDELs(WS)
%
disp('Finished calculating DEL table. Saving...');
save(['..\LUT_database\' inflowSetName '.mat'],'matDELs','table','WS')