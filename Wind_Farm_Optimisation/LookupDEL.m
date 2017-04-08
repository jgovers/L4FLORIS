function [DEL,filenumber] = LookupDEL(Dw3,C2C,Ueff,Ueff_matrix,DEL_summary,...
    N, D, U, Dw3_vector, C2C_vector, Ueff_vector, sim_name)
dispErrors = false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Uniform wind field %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DEL = 0;

% Discretization
% Region 3 wake diameter discretization
if Dw3 == 0
    Dw3_field = 1; %<----- check this value!
end

if   Dw3 > 0 && Dw3 < Dw3_vector(1)
    
    if dispErrors; display('Wake diameter not in dataset. The smallest possible wake diameter was selected'); end;
    Dw3_field = 1; %<----- check this value!
end

for Dw3_step = 1:length(Dw3_vector)-1
    if Dw3 >= Dw3_vector(Dw3_step) && Dw3 <= Dw3_vector(Dw3_step+1)
        Dw3_field = Dw3_step+1; %<----- check this value!
    end
end

if Dw3 > Dw3_vector(end)
    if dispErrors; display('Wake diameter not in dataset. The largest possible wake diameter was selected'); end;
%     disp(['Dw3 has value: ' num2str(Dw3)]);
%     disp(['Dw3_vector(end):' num2str(Dw3_vector(end))]);
    Dw3_field = length(Dw3_vector);
end

% Center-2-Center distance discretization
if C2C < C2C_vector(1)
    if dispErrors; display('Center-2-Center distance not in dataset. The most negative C2C distance was selected'); end;
    C2C_field = 1;
end

for C2C_step = 1:length(C2C_vector)-1
    if C2C == C2C_vector(C2C_step)
        C2C_field = C2C_step;
    end
    if C2C >= C2C_vector(C2C_step) && C2C <= C2C_vector(C2C_step+1)
        C2C_field = C2C_step;
    end
end

if C2C > C2C_vector(end)
    if dispErrors; display('Center-2-Center distance not in dataset. The most positive C2C distance was selected'); end;
    C2C_field = length(C2C_vector);
end

search_vector = Ueff_matrix(C2C_field,Dw3_field,:);
[c index] = min(abs(search_vector-Ueff));
Ueff_field = index;

% Find DEL
% The DEL values from the data-set which is compiled using FAST and MLIFE
% Load DEL_MATRIX
%     Dw3_vector = [D D+100 D+200 D+300];
%     C2C_vector = [-100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100];
%     Ueff_vector = [1 0.8 0.6];
%%
fullsize = length(Dw3_vector)*length(C2C_vector)*length(Ueff_vector);
medsize = length(C2C_vector)*length(Ueff_vector);
smallsize = length(Ueff_vector);
%%
narrow1 = 0;
for i = 1:length(Dw3_vector)
    narrow1(i+1) = i*medsize;
end
search1 = narrow1(Dw3_field);
narrow2 = 0;
for i = 1:length(C2C_vector)
    narrow2(i+1) = i*smallsize;
end
search2 = narrow2(C2C_field);

filenumber = search1+search2+Ueff_field;

DEL = sum(DEL_summary(filenumber,1:3))/3;
end