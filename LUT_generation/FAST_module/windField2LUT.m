% Set up settings
mlifeSettings   = 'calculate_DEL_v2.mlif';  % Mlife settings file

% Load FAST
load('Controller_parameters');   % Load FAST settings
addpath(genpath('Source'))       %Load Path needed for execution of this code
addpath(genpath('slprj'))        %Load Path needed for execution of this code
addpath(genpath('subfunctions')) %Load Path needed for execution of this code
addpath(genpath('Data'))         %Load Path needed for execution of this code
addpath(genpath('Outputs'))      %Load Path needed for execution of this code

% Import inflow profiles
WS       = load(['..\inflowProfiles\' inflowSetName '\workspace.mat']);
wndFiles = dir(['..\inflowProfiles\' inflowSetName '\*.wnd']);
sumFiles = dir(['..\inflowProfiles\' inflowSetName '\*.sum']);
N        = length(wndFiles);
T        = WS.T;  % simulation time in seconds
dt       = WS.dt; % sampling time in seconds

DEL_table = zeros(N,3);
for iter = 1:N
    delete('wind.*'); % Delete existing wind files and overwrite new
    copyfile(['..\inflowProfiles\' inflowSetName '\' wndFiles(iter).name],'wind.wnd');
    copyfile(['..\inflowProfiles\' inflowSetName '\' sumFiles(iter).name],'wind.sum');
    outputDirectory = [cd '\MLife_out\' wndFiles(iter).name(1:end-4)];
    mkdir(outputDirectory);
   
    sim('NREL5MW_Baseline_loads_2014b')  % Simulate FAST
    [fatigue, statistics] = mlife(mlifeSettings, cd, outputDirectory); % Simulate MLife
    
    % Process data from MLife
    [~,~,rawXlsx]     = xlsread([outputDirectory '\inter_result_Short-term.xlsx'],2);
    DEL_table(iter,:) = cell2mat(rawXlsx(9,[4:6]));
end;