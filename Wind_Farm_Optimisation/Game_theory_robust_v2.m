%% Initialize GT-theory parameters
global N D U T dt
global Dw3_vector C2C_vector Ueff_vector sim_name

addpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Ueff'))                    
name1 = strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Ueff\Ueff_matrix.mat');
load(name1)
% Load DEL matrix
addpath(strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM'))                      %Load Path needed for execution of this code
name2 = strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM\DEL_summary_',num2str(sim_name),'.mat');
load(name2)
%% Optimization parameters
optconst = 1;                               % Weighting factor                                                  
iterations = 100%000;                          % Iterations        [-] 
% iterations = 100;   
alpha = 0.025;                              % Sensitivity       [-]
% alpha = 0.5;
% alpha = /(iterations-(iterations/1.5));  % Sensitivity       [-]
%% Figure
% E = zeros(iterations,1);
% for k = 1:1:iterations
% E(k) = 1/(alpha*k);
% end
% figure
% hold on
% plot(1:1:iterations,E)
% plot([1 iterations],[1 1]);
% legend('E','R1')
% ylim([0 2]);
%% Set Wind Turbine Positions and yaw constraints
run GeminiFirstHalf.m

N  = length(Xc);            % Total amount of WT's          [-]
yawmax = 30*(pi/180);       % Smallest yaw angle            [radians]
yawmin = -1*yawmax;         % Biggest yaw angle             [radians]

%% Set FLORIS parameters
rho  = 1.17;                % Air Density                   [kg/m^3]
ai   = 1/3;                 % Axial Induction Factor        [-]
lf   = 0.768;               % Loss Factor                   [-]
PP   = 1.88;                % Parameter value               [-]
A    = pi*(D/2)^2;          % Rotor Swept Area              [m^2]
m_e  = [-0.5 0.22 1];       % Gebraad                       [-]
k_e  = 0.065;               % Gebraad                       [-]
a_d  = -4.5;                % Gebraad                       [-]
b_d  = -0.01;               % Gebraad                       [-]
k_d  = 0.17;                % Gebraad                       [-]
M_U  = [0.5 1 5.5];         % Gebraad                       [-]
a_U  = 5;                   % Gebraad                       [-]
b_U  = 1.66;                % Gebraad                       [-]
%% Initialize FLORIS matrices
U    = zeros(N,1);          % Wind speeds                   [m/s]
P    = zeros(N,1);          % Power                         [W] 
yw   = zeros(N,N);          % Wake width per WT-location    [m]
Dw   = zeros(N,N,3);        % Wake diameters (3x)           [m]
c    = zeros(N,N,3);        % ?                             [?]
n    = linspace(1,N,N);     % ?                             [?]
%% Controlled input
U(1) = 10;                  % Static Wind Speed             [m/s]
%% Weight vector
Udir_vector = [-16:4:16];
x = [-24:0.1:24];
% alpha = 1/normpdf(0,0,8);

Udir_weight_vector = zeros(length(Udir_vector),1);
for Udir_vector_step = 1:length(Udir_vector)
    Udir_weight_vector(Udir_vector_step,1) = normpdf(Udir_vector(Udir_vector_step),0,8);
end
Udir_weight_sum = sum(Udir_weight_vector);

beta = (1/Udir_weight_sum);
norm = beta*normpdf(x,0,8);
Udir_weight_vector = zeros(length(Udir_vector),1);
for Udir_vector_step = 1:length(Udir_vector)
    Udir_weight_vector(Udir_vector_step,1) = beta*normpdf(Udir_vector(Udir_vector_step),0,8);
end
Udir_weight_sum = sum(Udir_weight_vector);

%% Figure
% grid on
% hold on
% plot(x,norm)
% plot((Udir_vector),Udir_weight_vector,'r.','MarkerSize',20)
% title('Normal distribution of wind directions')
% xlabel('Degrees [^o]')
% ylabel('Probability [-]')
%% Initialize GT-theory matrices    
Pdir = zeros(1,1);
Pdirall = zeros(iterations,1);
Pdirbaseall = zeros(iterations,1);
Pnombaseall = zeros(iterations,1);

DELdir = zeros(1,1);
DELdirall = zeros(iterations,1);
DELdirbaseall = zeros(iterations,1);
DELnombaseall = zeros(iterations,1);

PDELdir = zeros(1,1);
PDELdirall = zeros(iterations,1);
PDELdirbaseall = zeros(iterations,1);
PDELtotnom = zeros(iterations,1);
PDELnombaseall = zeros(iterations,1);

yaw = zeros(N,1);                       % Initialize yaw matrix         [radian]
yawall = zeros(iterations,N);            % Initialize yawall matrix      [radian]
yawbase = yaw;
%% Non optimized Wind Farm Power
store_Ptot = zeros(1,length(Udir_vector));
store_DELtot = zeros(1,length(Udir_vector));
for Udir_vector_step = 1:length(Udir_vector)
    Udir = Udir_vector(Udir_vector_step);
    %% Find Turbine Positions w.r.t. Incoming Wind Direction
    % Find down-/crosswind turbine coordinates
    for i = 1 : N
        Xt(i) = cos(-Udir)*Xc(i) + -sin(-Udir)*Yc(i); % Translated Xc-coordinates
        Yt(i) = sin(-Udir)*Xc(i) + cos(-Udir)*Yc(i);  % Translated Yc-coordinates
    end

    % Find front (most upwind) turbine:  
    Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
    NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

    X = NewPos(:,1);                    % Extracting the X-coordinates
    Y = NewPos(:,2);                    % Extracting the Y-coordinates

    X = X - min(X);                     % Discarding non-used X
    Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
    %% Power
    [ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
    [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
    store_Ptot(1,Udir_vector_step) = Ptot;
    store_DELtot(1,Udir_vector_step) = DELtot;
end
sum_Ptot = store_Ptot*Udir_weight_vector;
sum_DELtot = store_DELtot*Udir_weight_vector;


Udir = 0;
%% Find Turbine Positions w.r.t. Incoming Wind Direction
% Find down-/crosswind turbine coordinates
for i = 1 : N
    Xt(i) = cos(-Udir)*Xc(i) + -sin(-Udir)*Yc(i); % Translated Xc-coordinates
    Yt(i) = sin(-Udir)*Xc(i) + cos(-Udir)*Yc(i);  % Translated Yc-coordinates
end

% Find front (most upwind) turbine:  
Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

X = NewPos(:,1);                    % Extracting the X-coordinates
Y = NewPos(:,2);                    % Extracting the Y-coordinates

X = X - min(X);                     % Discarding non-used X
Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
%% Power
[ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
[DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);

Pdir(1)                 = sum_Ptot;
Pdirall(1)              = sum_Ptot;
Pdirbase                = sum_Ptot;
Pdirbaseall(1)          = sum_Ptot;
Pnom(1)                 = Ptot;
Pnombase                = Ptot;
Pnombaseall(1)          = Ptot;


DELdir(1)               = sum_DELtot;
DELdirall(1)            = sum_DELtot;
DELdirbase              = sum_DELtot;
DELdirbaseall(1)        = sum_DELtot;
DELnom(1)               = DELtot;
DELnombase              = DELtot;
DELnombaseall(1)        = DELtot;

PDELdir(1)              = 1-optconst*1;
PDELdirall(1)           = 1-optconst*1;
PDELdirbase             = 1-optconst*1; 
PDELdirbaseall(1)       = 1-optconst*1; 
PDELnom(1)              = 1-optconst*1;
PDELnombase             = 1-optconst*1;
PDELnombaseall(1)       = 1-optconst*1;
%% ------------------------------------------------------------------------%
% -----------------------------GAME THEORY---------------------------------%
% -------------------------------------------------------------------------%

h = waitbar(0,'GameTheory Combined');
for k = 2:iterations            % k is the number of iterations
    for i = 1:N                 % For each WT                                   [-]
        R1 = rand();            % Random value between                          [0 1]
        E = 1/(alpha*k);        % Sensitivity linearly related to iteration
        if R1 < E
            R2 = normrnd(0,35)*(pi/180);  % random value                        [0 10]       
            if yawbase(i)+R2 <= 0
                yaw(i) = max(yawbase(i)+R2,yawmin);  % Yaw-angle must be bigger than the minimum yaw angle
            else
                yaw(i) = min(yawbase(i)+R2,yawmax);  % Yaw-angle must be smaller than the maximal yaw angle
            end
        else
            yaw(i) = yawbase(i);   % Old yaw setting                [radians]
        end
        yawall(k,i) = yaw(i);   % Remeber yaw setting           [radians]
    end

    Ptot = 0;                       % Reset Total Power             [W]
    DELtot = 0;                     % Reset DEL                     [-]

    for Udir_vector_step = 1:length(Udir_vector)
        Udir = Udir_vector(Udir_vector_step);
        %% Find Turbine Positions w.r.t. Incoming Wind Direction
        % Find down-/crosswind turbine coordinates
        for i = 1 : N
        Xt(i) = cos(-Udir)*Xc(i) + -sin(-Udir)*Yc(i); % Translated Xc-coordinates
        Yt(i) = sin(-Udir)*Xc(i) + cos(-Udir)*Yc(i);  % Translated Yc-coordinates
        end

        % Find front (most upwind) turbine:  
        Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
        NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

        X = NewPos(:,1);                    % Extracting the X-coordinates
        Y = NewPos(:,2);                    % Extracting the Y-coordinates

        X = X - min(X);                     % Discarding non-used X
        Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
        %% Calculate amount of Power and Load
        [ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
        [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
        store_Ptot(1,Udir_vector_step) = Ptot;
        store_DELtot(1,Udir_vector_step) = DELtot;
    end  
    
    sum_Ptot = store_Ptot*Udir_weight_vector;
    sum_DELtot = store_DELtot*Udir_weight_vector;
    sum_PDELtot = (sum_Ptot/Pdir(1))-optconst*(sum_DELtot/DELdir(1)); % Generate Power & Load total
    
    
    Udir = 0;
    %% Find Turbine Positions w.r.t. Incoming Wind Direction
    % Find down-/crosswind turbine coordinates
    for i = 1 : N
        Xt(i) = cos(-Udir)*Xc(i) + -sin(-Udir)*Yc(i); % Translated Xc-coordinates
        Yt(i) = sin(-Udir)*Xc(i) + cos(-Udir)*Yc(i);  % Translated Yc-coordinates
    end

        % Find front (most upwind) turbine:  
    Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
    NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

    X = NewPos(:,1);                    % Extracting the X-coordinates
    Y = NewPos(:,2);                    % Extracting the Y-coordinates

    X = X - min(X);                     % Discarding non-used X
    Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
    
    [ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
    [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
    PDELtotnom = (Ptot/Pnom(1))-optconst*(DELtot/DELnom(1)); % Generate Power & Load total  

    %% Uncomment this if-loop for garanteed power incresement w.r.t non optimized case        
    if sum_Ptot>Pdirbase       % New Power tot. must be bigger than the power when non-optimized        
        if sum_PDELtot>PDELdirbase
            yawbase = yaw;  % Overwrite the yawbase settings with the new yaw settings
            Pdirbase = sum_Ptot;   % Overwrite the Powerbase results with the new Power total results
            DELdirbase = sum_DELtot;
            PDELdirbase = sum_PDELtot;
            Pnombase = Ptot;
            DELnombase = DELtot;
            PDELnombase = PDELtotnom;
        end
    end
    
    Pnombaseall(k) = Pnombase;
    DELnombaseall(k) = DELnombase;
    PDELnombaseall(k) = PDELnombase;
    
    Pdirall(k) = sum_Ptot;         % Remember Power total
    Pdirbaseall(k) = Pdirbase;
    
    DELdirall(k) = sum_DELtot;         % Remember Power total
    DELdirbaseall(k) = DELdirbase;

    PDELdirall(k) = sum_PDELtot;         % Remember Power total
    PDELdirbaseall(k) = PDELdirbase;
    
    waitbar(k/iterations)        % Update waitbar
end
close(h)

%% Recalculate for final plot
% Udir = 0;
% %% Find Turbine Positions w.r.t. Incoming Wind Direction
% % Find down-/crosswind turbine coordinates
% for i = 1 : N
% Xt(i) = cos(-Udir)*Xc(i) + -sin(-Udir)*Yc(i); % Translated Xc-coordinates
% Yt(i) = sin(-Udir)*Xc(i) + cos(-Udir)*Yc(i);  % Translated Yc-coordinates
% end
% 
% % Find front (most upwind) turbine:  
% Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
% NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value
% 
% X = NewPos(:,1);                    % Extracting the X-coordinates
% Y = NewPos(:,2);                    % Extracting the Y-coordinates
% 
% X = X - min(X);                     % Discarding non-used X
% Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
% %% Calculate amount of Power and Load
% [ P_zero,Ptot_zero,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);

%% FIGURE BUILDING
figure
hold on
plot(PDELdirbaseall,'Linewidth',2)
plot(PDELnombaseall,'LineWidth',2)
grid on
title('Mixed optimization: Power & Load')
ylabel('PL-score [-]')
xlabel('Iterations [-]')

%%
figure
hold on
plot(Pdirbaseall/1E6,'Linewidth',2)
plot(Pnombaseall/1E6,'LineWidth',2)
grid on
title('Power increase')
ylabel('Power [MW]')
xlabel('Iterations [-]')

%%
figure
hold on
plot(DELdirbaseall/1E6,'Linewidth',2)
plot(DELnombaseall/1E6,'LineWidth',2)
grid on
title('Load decrease')
ylabel('DEL x10^6')
xlabel('Iterations [-]')

%% PLOT TURBINES
figure
hold on
    
    for i = 1:N-1
    % wake q = 3
    fill([X(i:end); flipud(X(i:end))], [(yw(i,i:end)+(Dw(i,i:end,3)/2))'; fliplr(yw(i,i:end)-(Dw(i,i:end,3)/2))'], 'y', 'FaceAlpha', 0, 'EdgeColor', 'y')
         
%     wake q = 2
    fill([X(i:end); flipud(X(i:end))], [(yw(i,i:end)+(Dw(i,i:end,2)/2))'; fliplr(yw(i,i:end)-(Dw(i,i:end,2)/2))'], 'g', 'FaceAlpha', 0, 'EdgeColor', 'g')

    % wake q = 1
    fill([X(i:end); flipud(X(i:end))], [(yw(i,i:end)+(Dw(i,i:end,1)/2))'; fliplr(yw(i,i:end)-(Dw(i,i:end,1)/2))'], 'b', 'FaceAlpha', 0, 'EdgeColor', 'b')                     
    end
%     
    for i = 1:N
%     % Turbine
    plot([(X(i)-.5*D*sin(yaw(i))) (X(i)+.5*D*sin(yaw(i)))], [(Y(i)+.5*D*cos(yaw(i))) (Y(i)-.5*D*cos(yaw(i)))], 'k', 'LineWidth', 2) 
    end
    
    for i=1:N-1
%     % Centerline
    plot(X(i:end), yw(i,i:end),'k') 
    end
    
scatter(X, Y)                                       %turbine position
labels = num2str([1:N]', '%d');                     %turbine index
text(X+0.05, Y, labels, 'VerticalAlignment','bottom')    
ylabel('Y-Distance [m]')
xlabel('X-Distance [m]')
title('Gemini Wind Farm')
%% Remove paths
rmpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Ueff'))
rmpath(strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM')) 