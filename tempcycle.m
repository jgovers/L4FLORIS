clear all; close all; clc;
paramsLoop   = {'a','b','c','d'};
rangeLoop    = {0.0:0.5:1.0,  1.2:0.2:1.6,  1.8:0.4:2.6,[1 2]};

% Create N-D output matrices
Nd            = [];
saveMatNames  = {};
saveMatValues = {};
saveMatIdx    = {};
paramsEval    = struct;
for i = 1:length(rangeLoop)
    Nd            = [Nd length(rangeLoop{i})];
    saveMatIdx{i} = 1;
end;

% Fill up N-D output matrix
[saveMatNames,saveMatValues,~] = cycle_loop( paramsEval,paramsLoop,rangeLoop,saveMatNames,saveMatValues,saveMatIdx,1 )