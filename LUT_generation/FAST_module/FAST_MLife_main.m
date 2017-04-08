%global N D U T dt
%global Dw3_vector C2C_vector Ueff_vector sim_name

% D = 129;                                    % Rotor Diameter        [m]
% U = 8;                                     % Ambient Wind speed    [m/s]
T = 100+100+76;                             % Duration of simulation[s] Initialization + usable for DEL analyses + discarded by FAST
dt = 0.125;                                % Time step size        [-]

% % Discretization of wake diameter of region 3
% Dw3_vector = [D+25 D+50 D+75 D+100 D+125 D+150 D+175 D+200];
% % Dw3_vector = [D+25];
% % Discretization of Center 2 Center distance (Rotor center & Wake center)
% C2C_vector = [-230 -220 -210 -200 -190 -180 -170 -160 -150 -140 -130 -120 -110 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230];
% % C2C_vector = [-90];
% % Discretization of effective wind velocity
% % Ueff_vector = [1 0.8 0.6];
% Ueff_vector = [0.8 0.6];
% %sim_name = 'NO_IPC_FINAL';

%% Calculate settings for the controller within the simulink model
load('Controller_parameters');                  
%% Add Path's (Including the wind fields)
addpath(genpath('Source'))                      %Load Path needed for execution of this code
addpath(genpath('slprj'))                       %Load Path needed for execution of this code
addpath(genpath('subfunctions'))                %Load Path needed for execution of this code
addpath(genpath('Data'))                        %Load Path needed for execution of this code
addpath(genpath('Outputs'))                     %Load Path needed for execution of this code
% %% Simulation settings
% Sim_tim = T;                          % Simulation time       [s]
% FAST_dt = dt;                       % Sample time FAST      [-]
%%
% iter_wf = 0;                                         % Set counter to zero [-]
% Tot_iter = length(Dw3_vector)*length(C2C_vector)*length(Ueff_vector);    % Total amount of simulations [-]
% DEL_summary = zeros(Tot_iter,3);                  % Initialize DEL summary matrix [-]   
%%
%mkdir('Outputs',sim_name)
% mkdir(strcat('Outputs\',num2str(sim_name)),'Data')
% mkdir(strcat('Outputs\',num2str(sim_name)),'DEL_and_SIM')
% mkdir(strcat('Outputs\',num2str(sim_name)),'Excel')
% addpath('Outputs')
%             
%h = waitbar(0,'Iterations Wind Field');     % Initialize sim-iteration counter [-]

for Ueff_vector_step = 1:1
    for Dw3_vector_step = 1:1      
        for C2C_vector_step= 1:1
            
%             iter_wf = iter_wf + 1;
            % USE THIS
%             iter_wf_v2 = strcat(num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step));
%             
%             name_wind1=strcat('..\Wind_Field_Generation\Outputs\',num2str(sim_name),'\WindFiles\WF_field','_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),'.wnd');         
%             name_wind2=strcat('..\Wind_Field_Generation\Outputs\',num2str(sim_name),'\WindFiles\WF_field','_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),'.sum');
%             copyfile(name_wind1,'wind.wnd')
%             copyfile(name_wind2,'wind.sum')

%             disp(strcat('Simulation',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),'started'))
%             if (b_choice_1 == 'y')
            %-------------------------------------------------------------%
%             clear sim_name
            sim('NREL5MW_Baseline_loads_2014b')    
            %sim('NREL5MW_Baseline_loads_IPC_1P_2P_v2_2015b')
%             sim('NREL5MW_Baseline_loads_IPC_1P_v3_2014b') % NO IPC, 1P IPC, 2P-1P IPC 
            %-------------------------------------------------------------%
            disp ('Simulation executed')
%             end
            
            name_data = strcat('Outputs\',num2str(sim_name),'\Data\data_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step));   % Make data_i for rerunning purposse  
            % BUILD SAME STRUCTURE AS WIND FILES
            copyfile('FASTTOOL_SFunc.out',name_data)             % Convert standard .out file to own data_i
            name_data2 = strcat('Outputs\',num2str(sim_name),'\Data\inter_data.out');
%             copyfile(name_data,'Data\inter_data.out')            % Generalize datafile for mlife file
            copyfile(name_data,name_data2)            % Generalize datafile for mlife file
            settingsFile = 'calculate_DEL_v2.mlif';
            dataDirectory = strcat(num2str(cd),'\Outputs\',num2str(sim_name),'\Data');
            
            %-------------------------------------------------------------%
            outputDirectory = strcat(num2str(cd),'\Outputs\',num2str(sim_name),'\Excel');
            %-------------------------------------------------------------%
            
            [fatigue, statistics] = mlife(settingsFile, dataDirectory, outputDirectory);
            
            % BUILD SAME STRUCTURE AS WIND FILES
            name1 = strcat('Outputs\',num2str(sim_name),'\Excel\',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),...
                '_Short-term_Damage_Rate.txt');
            name2 = strcat('Outputs\',num2str(sim_name),'\Excel\',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),...
                '_Short-term_DEL.txt');
            name3 = strcat('Outputs\',num2str(sim_name),'\Excel\',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),...
                '_Short-term.xlsx');
            name4 = strcat('Outputs\',num2str(sim_name),'\Excel\',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),...
                '_Lifetime.xlsx');
            
            copyfile(strcat('Outputs\',num2str(sim_name),'\Excel\inter_result_Short-term_Damage_Rate.txt'),name1)
            copyfile(strcat('Outputs\',num2str(sim_name),'\Excel\inter_result_Short-term_DELs.txt'),name2)
            copyfile(strcat('Outputs\',num2str(sim_name),'\Excel\inter_result_Short-term.xlsx'),name3)
            copyfile(strcat('Outputs\',num2str(sim_name),'\Excel\inter_result_Lifetime.xlsx'),name4)
    
            xlsx_name = strcat('Outputs\',num2str(sim_name),'\Excel\',...
                num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),...
                '_Short-term.xlsx');
            [~,~,raw] = xlsread(xlsx_name,2);
            DEL_value = cell2mat(raw(9,[4:6]));
            DEL_summary(iter_wf,:) = cell2mat(raw(9,[4:6]));
            
            %Store OutData 
            name_DEL_k=strcat('DEL_value_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),'.mat');
            save(name_DEL_k,'DEL_value')
            movefile(name_DEL_k,strcat('Outputs\',num2str(sim_name),'\DEL_and_SIM'))
            
            %Store OutData
            name_OutData=strcat('Outdata_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),'.mat');
            save(name_OutData,'OutData')
            movefile(name_OutData,strcat('Outputs\',num2str(sim_name),'\DEL_and_SIM'))

            waitbar(iter_wf/Tot_iter)          
        end
    end
end
close(h)
%% Save Output data
name1 = strcat('DEL_summary_',num2str(sim_name),'.mat');
save(name1,'DEL_summary','-v7.3');
movefile(name1,strcat('Outputs\',num2str(sim_name),'\DEL_and_SIM'))
disp('Output saved')
%% Clear dispensable data
clearvars -except a_choice b_choice c_choice d_choice Dw3_vector C2C_vector Ueff_vector sim_name N U D T dt Sim_data