% Set up settings
mlifeSettings   = 'calculate_DEL_v2.mlif';  % Mlife settings file

% Load FAST
% load('Controller_parameters');   % Load FAST settings
% addpath(genpath('Source'))       %Load Path needed for execution of this code
% addpath(genpath('slprj'))        %Load Path needed for execution of this code
% addpath(genpath('subfunctions')) %Load Path needed for execution of this code
% addpath(genpath('Data'))         %Load Path needed for execution of this code
% addpath(genpath('Outputs'))      %Load Path needed for execution of this code
% addpath('..');

% Import inflow profiles
T  = WS.inputData.T;  % simulation time in seconds
dt = WS.inputData.dt; % sampling time in seconds

% Import windfiles based on LUTsettings.m
delete('wind.*'); % Delete existing wind files and overwrite new
copyfile(['..\' filename '.wnd'],'wind.wnd');
copyfile(['..\' filename '.sum'],'wind.sum');
outputDirectory = [cd '\MLife_out\' filename];
mkdir(outputDirectory);

% Simulate Simulink
sim('NREL5MW_Baseline_loads_2014b')  % Simulate FAST

% Simulate MLife
[fatigue, statistics] = mlife(mlifeSettings, cd, outputDirectory); 

% Process data from MLife
[~,~,rawXlsx] = xlsread([outputDirectory '\inter_result_Short-term.xlsx'],2);
DEL           = mean(cell2mat(rawXlsx(9,[4:6]))); % Take mean or? Which components DEL do we pick?
