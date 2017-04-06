%% Initialize
% Create global variables
global N D U T dt
global Dw3_vector C2C_vector Ueff_vector sim_name

addpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Ueff'))                    
name1 = strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Ueff\Ueff_matrix.mat');
load(name1)
% Load DEL matrix
addpath(strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM'))                      %Load Path needed for execution of this code
name2 = strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM\DEL_summary_',num2str(sim_name),'.mat');
load(name2)
%% Initialize GT-theory parameters
optconst = 1;                       % Weighting factor                                                  
iterations = 10000;                        % Iterations        [-] 
alpha = 0.025;                              % Sensitivity       [-]
%% Set Wind Turbine Positions
run GeminiFirstHalf.m
% run Gemini.m

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
Udir = 0;                   % Wind direction                [radians]
U(1) = 10;                  % Static Wind Speed             [m/s]
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


%% Initialize GT-theory matrices
Pall = zeros(iterations,1);              % Initialize Pall matrix        [W]
Pallmax = zeros(iterations,1);           % Initialize Pallmax matrix     [W]

Lall = zeros(iterations,1);              % Initialize Lall matrix        [?]
Lallmin = zeros(iterations,1);           % Initialize Lallmin matrix     [?]

PLall = zeros(iterations,1);             % Initialze PL matrix           [-]
PLallmax = zeros(iterations,1);          % Initialize PLall matrix       [-]

yaw = zeros(N,1);                   % Initialize yaw matrix         [radian]
yawall = zeros(iterations,N);            % Initialize yawall matrix      [radian]
yawbase = yaw;

%% Non optimized Wind Farm Power
[ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
[DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
%% OPTIMIZATION PART
Pnonopt = Ptot;
Lnonopt = DELtot;                        % Non optim. load exp.          [?]  

Pall(1) = Pnonopt;                  % Set non optim. as first data point [-]
Pallmax(1)=Pnonopt;

Lall(1) = Lnonopt;                  % Set non optim. as first data point [-]
Lallmin(1)=Lnonopt;

Pbase = Pnonopt;                    % Initialize Pbase with Pnonopt     [W]
Lbase = Lnonopt;                    % Initialize Lbase with Lnonopt     [L]

PLbase = 1-optconst*1;              % Set opt. base                     [-]


%-------------------------------------------------------------------------%
%------------GAME THEORY MIXED OPTIMIZATION OBJECTIVE---------------------%
%-------------------------------------------------------------------------%
tic
h = waitbar(0,'GameTheory Combined');
    for k = 2:iterations       % k is the number of iterations

        for i = 1:N                 % For each WT                                   [-]
            R1 = rand();            % Random value between                          [0 1]
            E = 1/(alpha*k);        % Sensitivity linearly related to iterations
            if R1 < E
                R2 = normrnd(0,35)*(pi/180);  % random value                        [0 10]       
                if yawbase(i)+R2 <= 0;
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
        Ltot = 0;                       % Reset Total Load              [-]
        
        [ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,Aol,Oup,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
        [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
        
        Ltot = DELtot;
        
        PLtot = (Ptot/Pnonopt)-optconst*(Ltot/Lnonopt); % Generate Power & Load total

        % Uncomment this if-loop for garanteed power incresement w.r.t non optimized case        
      if Ptot>Pnonopt       % New Power tot. must be bigger than the power when non-optimized        
            if PLtot > PLbase   % Power & Load total must be bigger than the Power & Load when non-optimized
                yawbase = yaw;  % Overwrite the yawbase settings with the new yaw settings
                Pbase = Ptot;   % Overwrite the Powerbase results with the new Power total results
                Lbase = Ltot;   % Overwrite the Loadbase results with the new Load results
                PLbase = PLtot; % Overwrite the Power & Load base settings with the new Power & Load setting
            end
      end
                
        Pall(k) = Ptot;         % Remember Power total
        Pallmax(k) = Pbase;     % Remember Powerbase
        
        Lall(k) = Ltot;         % Remember Load total
        Lallmin(k) = Lbase;     % Remember Load base
        
        PLall(k) = PLtot;       % Remember Power & Load total
        PLallmax(k) = PLbase;   % Rememver Power & Load base
        waitbar(k/iterations)        % Update waitbar
    end
close(h)
toc

%% FIGURE BUILDING
figure
plot(PLallmax,'Linewidth',2)
grid on
title('Mixed optimization: Power & Load')
ylabel('PL-score [-]')
xlabel('Iterations [-]')

figure
plot((Pallmax/1E6),'Linewidth',2)
grid on
title('Power increase')
ylabel('Power [MW]')
xlabel('Iterations [-]')

figure
plot(Lallmin/1E6,'Linewidth',2)
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
         
    % wake q = 2
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
title('1^{st} half Gemini Wind Farm')
% legend('Mixing wake zone','Location','southwest')
legend('Mixing wake zone','Outer wake zone','Inner wake zone','Location','southwest')
%% Remove paths
rmpath(strcat('Wind_Field_Generation\Outputs\',num2str(sim_name),'\Ueff'))
rmpath(strcat('FAST_Analysis\Outputs\',num2str(sim_name),'\DEL_and_SIM')) 