% Set up settings
mlifeSettings   = 'calculate_DEL_v2.mlif';  % Mlife settings file

% Load FAST
load('Controller_parameters');   % Load FAST settings
addpath(genpath('Source'))       %Load Path needed for execution of this code
addpath(genpath('slprj'))        %Load Path needed for execution of this code
addpath(genpath('subfunctions')) %Load Path needed for execution of this code
addpath(genpath('Data'))         %Load Path needed for execution of this code
addpath(genpath('Outputs'))      %Load Path needed for execution of this code
addpath('..');

% Import inflow profiles
WS = load(['..\inflowProfiles\' inflowSetName '\workspace.mat']);
T  = WS.T;  % simulation time in seconds
dt = WS.dt; % sampling time in seconds

% Import windfiles based on LUTsettings.m
N = length(C2C_range);
table = zeros(N,3);
for iter = 1:N
    delete('wind.*'); % Delete existing wind files and overwrite new
    filename = inflowFilename(C2C_range(iter));
    copyfile(['..\inflowProfiles\' inflowSetName '\' filename '.wnd'],'wind.wnd');
    copyfile(['..\inflowProfiles\' inflowSetName '\' filename '.sum'],'wind.sum');
    outputDirectory = [cd '\MLife_out\' filename];
    mkdir(outputDirectory);
   
    sim('NREL5MW_Baseline_loads_2014b')  % Simulate FAST
    [fatigue, statistics] = mlife(mlifeSettings, cd, outputDirectory); % Simulate MLife
    
    % Process data from MLife
    [~,~,rawXlsx] = xlsread([outputDirectory '\inter_result_Short-term.xlsx'],2);
    table(iter,:) = mean(cell2mat(rawXlsx(9,[4:6])));
end;