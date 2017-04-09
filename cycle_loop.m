function [saveMatNames,saveMatValues,saveMatIdx] = cycle_loop( paramsEval,paramsLoop,rangeLoop,saveMatNames,saveMatValues,saveMatIdx,Ld )
%Nested loop for N-dimensional LUT generation
% Ld = loop depth
if length(paramsLoop) >= 1
    for i = 1:length(rangeLoop{1})
        saveMatIdx{Ld} = i;
        paramsEval.(paramsLoop{1}) = rangeLoop{1}(i); % Update corresponding parameter
        [saveMatNames,saveMatValues,saveMatIdx] = cycle_loop(paramsEval,{paramsLoop{2:end}},{rangeLoop{2:end}},saveMatNames,saveMatValues,saveMatIdx,Ld+1);
        
        % Save data
        if length(paramsLoop) == 1  % Save data at lowest level
            
            % Save file names corresponding to entries
            elementNames = fieldnames(paramsEval);
            nametemp = [];
            for j = 1:length(elementNames)
                nametemp = [nametemp elementNames{j} '=' num2str(paramsEval.(elementNames{j}))];
            end;
            saveMatNames{saveMatIdx{:}}  = nametemp;
            saveMatValues{saveMatIdx{:}} = 0.5;
        end
    end;
end

