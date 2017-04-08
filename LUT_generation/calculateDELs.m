%% Just a placeholder file to run from main directory
clear all; close all; clc;

% Settings
inflowSetName   = 'onlyC2C';  % Source folder name of inflow profiles

% Call in-folder file for processing
cd FAST_module
run('windField2LUT');
cd ..