global D U T dt
global Dw3_vector C2C_vector Ueff_vector sim_name

name1 = strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM\DEL_summary_',num2str(sim_name),'.mat');
addpath(strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM'))                      %Load Path needed for execution of this code
load(name1)

size1 = length(Dw3_vector)*length(C2C_vector);
size2 = length(C2C_vector);

% Extract the correct DEL-sequences
for Ueff_vector_step = 1: length(Ueff_vector)
    for Dw3_vector_step = 1:length(Dw3_vector)
        for C2C_vector_step = 1:length(C2C_vector)        
            seq(Dw3_vector_step,C2C_vector_step,Ueff_vector_step) = DEL_summary(size1*(Ueff_vector_step -1)+size2*(Dw3_vector_step-1)+(C2C_vector_step-1)+1);
        end
    end
end
% Maintain the same lay-out as output lay-out from FAST

% Generate Graphs
ll  = length(C2C_vector);
for Ueff_vector_step = 1:length(Ueff_vector)
    figure
    hold on
    grid on
    title_name = strcat('DEL-graph-',num2str(Ueff_vector(Ueff_vector_step)));
    for i = 1:length(Dw3_vector)
        plot(1:length(C2C_vector),(seq(i,:,Ueff_vector_step)/1E6))
    end
    title(title_name)
    xlabel('C2C distance [m]')
    set(gca, 'xtick', [1 (ll-1)/2+1 ll],'xticklabel',[C2C_vector(1) C2C_vector((ll-1)/2+1) C2C_vector(end)])
%     xticks(1:1:length(C2C_vector))
%     xticklabels(C2C_vector)
    ylabel('DEL x10^6')
    for k=1:length(Dw3_vector)
        textleg(k)={['Dw3 = ' num2str(Dw3_vector(k))]};
    end
    legend(textleg);
end