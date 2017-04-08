%% Just a placeholder file to run from main directory
clear all; close all; clc;

run('LUTsettings');    % Load LUT settings used for wind field generation
cd FAST_module         % Go into FAST folder
run('windField2LUT');  % Call in-folder file for processing
cd ..                  % Return to initial working directory
disp('Finished calculating DEL table. Reformatting...');
save(['..\LUT_database\' inflowSetName '.mat'],'C2C_range','table')
disp(['New LUT succesfully generated with name "' inflowSetName '.mat".']);