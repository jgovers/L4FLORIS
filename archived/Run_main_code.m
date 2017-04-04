% To do:
% Change save layout of FAST_MLife_main
% Build Wind file graphs optional
% clear var -except of FAST_MLife_main
%% Clean up
% Clear workspace, command window and close all figures
clear all; close all; clc;
%% Input by user
global N D U T dt
global Dw3_vector C2C_vector Ueff_vector sim_name

D = 129;                                    % Rotor Diameter        [m]
U = 10;                                     % Ambient Wind speed    [m/s]
T = 100+100+76;                             % Duration of simulation[s] Initialization + usable for DEL analyses + discarded by FAST
dt = 0.125;                                % Time step size        [-]

% Discretization of wake diameter of region 3
Dw3_vector = [D+25 D+50 D+75 D+100 D+125 D+150 D+175 D+200];
% Dw3_vector = [D+25];
% Discretization of Center 2 Center distance (Rotor center & Wake center)
C2C_vector = [-230 -220 -210 -200 -190 -180 -170 -160 -150 -140 -130 -120 -110 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230];
% C2C_vector = [-90];
% Discretization of effective wind velocity
% Ueff_vector = [1 0.8 0.6];
Ueff_vector = [0.8 0.6];
%% Processes to be execute
sim_name = input('How would you like to name this simulation?', 's'); 
a_choice = input('Do you like to create new wind fields? y/n ', 's'); 
b_choice = input('Do you like to run FAST analysis? y/n ', 's');
% b_choice_1 = input('Would you like to simulate with IPC disabled(choose 1 option)? y/n ', 's');
% b_choice_2 = input('Would you like to simulate with IPC enabled(choose 1 option)? y/n ', 's');
c_choice = input('Do you like to run the wind farm optimisation? y/n ', 's'); 
d_choice = input('Do you like to display the DEL-graph? y/n ', 's'); 
%% Wind field generation
if (a_choice == 'y' )
    disp('Wind field creation has started')
    addpath('Wind_Field_Generation')
    run Wind_Field_Generation\WFgen_v4.m
    rmpath('Wind_Field_Generation')
    disp('Wind field creation has finished')
else
    a_choice = 'n';
    disp('Skip wind field generation')   
end
%% FAST % Mlife analysis
if (b_choice == 'y' )
    disp('FAST analysis has started')
    addpath('FAST_Analysis')
    addpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\WindFiles'))                      %Load Path needed for execution of this code <--- warning /    
    cd('FAST_Analysis')
    run FAST_MLife_main.m
    cd('..\')
    rmpath('FAST_Analysis')
%     rmpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Windfiles'))
else
    b_choice = 'n';
    disp('Skip FAST analysis')   
end
%% Wind Farm optimisation 
if (c_choice == 'y' )
    disp('Wind farm optimisation has started') 
    addpath(genpath('Wind_Farm_Optimisation'))
%     run Wind_Farm_Optimisation.m
%     run Game_theory_robust.m
    run Game_theory_robust_v2.m
    rmpath(genpath('Wind_Farm_Optimisation'))
    disp('Wind farm optimisation has finished') 
else
    c_choice = 'n';
    disp('Skip wind farm optimisation')   
end
%% Generate Graphs 
if (d_choice == 'y' )
    disp('Generation of graphs has started') 
    addpath(genpath('Generate_Graphs'))
    run DEL_graph
    rmpath(genpath('Generate_Graphs'))
    disp('Generation of graphs has finished')
else
    d_choice = 'n';
    disp('Skip generation of graphs')   
end
%% Finish
disp('The process has been executed successfully')