clear all; close all; clc;
global U T dt

% Set up settings
inflowSetName   = 'onlyC2C';    % Destination folder name
       
% Load FAST and import inflow files
cd('FAST_module');
addpath(genpath('Source'))          %Load Path needed for execution of this code
addpath(genpath('slprj'))           %Load Path needed for execution of this code
addpath(genpath('subfunctions'))    %Load Path needed for execution of this code
addpath(genpath('Data'))            %Load Path needed for execution of this code
load('Controller_parameters');      % Load FAST settings
WS       = load(['..\inflowProfiles\' inflowSetName '\workspace.mat']);
wndFiles = dir(['..\inflowProfiles\' inflowSetName '\*.wnd']);
sumFiles = dir(['..\inflowProfiles\' inflowSetName '\*.wnd']);
N        = length(wndFiles);
T        = WS.T;  % simulation time in seconds
dt       = WS.dt; % sampling time in seconds
U        = 8.0; 
Sim_tim = T;                          % Simulation time       [s]
FAST_dt = dt;                       % Sample time FAST      [-]

for i = 1:1
    delete('wind.*'); % Delete existing wind files and overwrite new
    copyfile(['..\inflowProfiles\' inflowSetName '\' wndFiles(i).name],'wind.wnd');
    copyfile(['..\inflowProfiles\' inflowSetName '\' sumFiles(i).name],'wind.sum');
    cd('FAST_module');
    sim('NREL5MW_Baseline_loads_2014b')
end;