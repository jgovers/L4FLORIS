clear all; close all; clc;

%% Input by user
global N D U T dt
global Dw3_vector C2C_vector Ueff_vector sim_name

D = 129;           % Rotor Diameter        [m]
U = 10;            % Ambient Wind speed    [m/s]
T = 100+100+76;    % Duration of simulation[s] Initialization + usable for DEL analyses + discarded by FAST
dt = 0.125;        % Time step size        [-]

Dw3_vector = D+25:25:200; % Discretization of wake diameter of region 3
C2C_vector = -230:10:230; % Discretization of Center 2 Center distance
Ueff_vector = [0.8 0.6];  % Discretization of effective wind velocity

sim_name            = '2p_IPC_FINAL';    % Simulation name: NO_IPC_FINAL or 1P_IPC_FINAL or 2p_IPC_FINAL
createNewWindFields = false;             % Create new wind fields
runFASTAnalaysis    = false;             % Run FAST analysis
runOptimization     = true;              % Run WF optimization
displayDELgraph     = true;              % Display DEL graph


% Wind field generation
if createNewWindFields
    disp('Generating new wind field files')
    addpath('Wind_Field_Generation')
    run Wind_Field_Generation\WFgen_v4.m
    rmpath('Wind_Field_Generation')
    disp('Wind field generation has finished')
else
    disp('Skipping wind field generation')   
end

% FAST and Mlife analysis
if (runFASTAnalaysis)
    disp('FAST analysis has started')
    addpath('FAST_Analysis')
    addpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\WindFiles'))                      %Load Path needed for execution of this code <--- warning /    
    run('./FAST_Analysis/FAST_MLife_main.m')
    rmpath('FAST_Analysis')
    disp('FAST analysis has finished')
else
    disp('Skipping FAST analysis')   
end

% WF optimisation 
if (runOptimization)
    disp('Wind farm optimisation has started') 
    addpath(genpath('Wind_Farm_Optimisation'))
    run Game_theory_robust_v2.m
    rmpath(genpath('Wind_Farm_Optimisation'))
    disp('Wind farm optimisation has finished') 
else
    disp('Skipping wind farm optimisation')   
end

% Generate Graphs
if (displayDELgraph)
    disp('Generation of graphs has started') 
    addpath(genpath('Generate_Graphs'))
    run DEL_graph
    rmpath(genpath('Generate_Graphs'))
    disp('Generation of graphs has finished')
else
    disp('Skip generation of graphs')   
end