nargin = 0; % Placeholder for "function" file
if nargin <= 0
    sim_name               = '2p_IPC_FINAL';
end;
if nargin <= 1
    optimStruct.optConst   = 1;     % Weighting factor                                                  
    optimStruct.iterations = 100;   % Iterations  [-] 
    optimStruct.alpha      = 0.025; % Sensitivity [-]
end;
if nargin <= 2
    modelStruct.maxYaw = +30*(pi/180);  % Largest  yaw angle [radians]
    modelStruct.minYaw = -30*(pi/180);  % Smallest yaw angle [radians]
    
    % First half of Gemini WF layout
    modelStruct.Xc     = [0 242.857142857143 469.523809523810 469.523809523810 696.190476190476 696.190476190476 971.428571428571 906.666666666667 922.857142857143 1149.52380952381 1149.52380952381 1149.52380952381 1343.80952380952 1343.80952380952 1392.38095238095 1457.14285714286 1635.23809523810 1521.90476190476 1716.19047619048 1602.85714285714 1619.04761904762 1942.85714285714 1797.14285714286 1959.04761904762 1878.09523809524 1878.09523809524 1861.90476190476 2104.76190476190 2250.47619047619 2363.80952380952 2137.14285714286 2299.04761904762 2234.28571428571 2088.57142857143 2282.85714285714 2088.57142857143 2428.57142857143 2574.28571428571 2574.28571428571 2412.38095238095 2590.47619047619 2509.52380952381 2315.23809523810 2914.28571428571 2752.38095238095 2898.09523809524 2736.19047619048 2736.19047619048 2890 3043.80952380952 2784.76190476190 2954.76190476190 2720 3043.80952380952 3157.14285714286 3286.66666666667 3060 3157.14285714286 3270.47619047619 3205.71428571429 3116.66666666667 3432.38095238095 3578.09523809524 3440.47619047619 3383.80952380952 3537.61904761905 3699.52380952381 3820.95238095238 3594.28571428571 3756.19047619048 3942.38095238095 3942.38095238095 4088.09523809524 4225.71428571429 4339.04761904762];
    modelStruct.Yc     = [3108.57142857143 2833.33333333333 3197.61904761905 2525.71428571429 2890 2250.47619047619 3254.28571428571 2590.47619047619 1942.85714285714 2995.23809523810 2299.04761904762 1651.42857142857 2720 1975.23809523810 1360 3335.23809523810 3060 2428.57142857143 2137.14285714286 1683.80952380952 1068.57142857143 3408.09523809524 2768.57142857143 2460.95238095238 1878.09523809524 1400.47619047619 785.238095238095 3108.57142857143 2792.85714285714 2541.90476190476 2201.90476190476 1926.66666666667 1602.85714285714 1109.04761904762 809.523809523810 485.714285714286 3497.14285714286 3157.14285714286 2242.38095238095 1319.52380952381 1052.38095238095 485.714285714286 194.285714285714 3561.90476190476 2817.14285714286 2517.61904761905 1942.85714285714 1635.23809523810 1335.71428571429 1052.38095238095 752.857142857143 461.428571428571 194.285714285714 3238.09523809524 2946.66666666667 2639.04761904762 2185.71428571429 1845.71428571429 1489.52380952381 777.142857142857 194.285714285714 2331.42857142857 2023.80952380952 1157.61904761905 477.619047619048 194.285714285714 1700 1416.66666666667 841.904761904762 493.809523809524 194.285714285714 1117.14285714286 777.142857142857 477.619047619048 194.285714285714];
    
    modelStruct.rho  = 1.17;                % Air Density                   [kg/m^3]
    modelStruct.ai   = 1/3;                 % Axial Induction Factor        [-]
    modelStruct.lf   = 0.768;               % Loss Factor                   [-]
    modelStruct.PP   = 1.88;                % Parameter value               [-]
    modelStruct.m_e  = [-0.5 0.22 1];       % Gebraad                       [-]
    modelStruct.k_e  = 0.065;               % Gebraad                       [-]
    modelStruct.a_d  = -4.5;                % Gebraad                       [-]
    modelStruct.b_d  = -0.01;               % Gebraad                       [-]
    modelStruct.k_d  = 0.17;                % Gebraad                       [-]
    modelStruct.M_U  = [0.5 1 5.5];         % Gebraad                       [-]
    modelStruct.a_U  = 5;                   % Gebraad                       [-]
    modelStruct.b_U  = 1.66;                % Gebraad                       [-]
    
    modelStruct.windSpeed         = 10.             % Wind speed in [m/s]
    modelStruct.windDirection     = 0.              % Wind direction nominal (degrees)
    modelStruct.windUncertainty   = [-16:4:16]      % Additional wind disturbance range (symmetric)
end;

%% Initialize GT-theory parameters
global T dt
global Dw3_vector C2C_vector Ueff_vector

load(['Wind_Field_Generation\Outputs\',sim_name,'\Ueff\Ueff_matrix.mat'])
load(['FAST_Analysis\Outputs\',sim_name,'\DEL_and_SIM\DEL_summary_',num2str(sim_name),'.mat'])

% Optimization parameters
optConst   = optimStruct.optConst;
iterations = optimStruct.iterations;
alpha      = optimStruct.alpha;

% Import model settings
Xc     = modelStruct.Xc;
Yc     = modelStruct.Yc;
yawmin = modelStruct.minYaw;
yawmax = modelStruct.maxYaw;

rho     = modelStruct.rho;
ai      = modelStruct.ai;
lf      = modelStruct.lf;
PP      = modelStruct.PP;
m_e     = modelStruct.m_e;
k_e     = modelStruct.k_e;
a_d     = modelStruct.a_d;
b_d     = modelStruct.b_d;
k_d     = modelStruct.k_d;
M_U     = modelStruct.M_U;
a_U     = modelStruct.a_U;
b_U     = modelStruct.b_U;

windSpeed      = modelStruct.windSpeed;       % Static Wind Speed [m/s]
windDirection  = modelStruct.windDirection;   % Nominal wind direction
windUncertainty= modelStruct.windUncertainty; % Wind direction disturbances

% Derive other parameters
N      = length(Xc);
D      = 126.4;
A      = 0.5*pi*(D/2)^2; 

% Initialize FLORIS matrices
P    = zeros(N,1);          % Power                         [W] 
yw   = zeros(N,N);          % Wake width per WT-location    [m]
Dw   = zeros(N,N,3);        % Wake diameters (3x)           [m]
c    = zeros(N,N,3);        % ?                             [?]
n    = linspace(1,N,N);     % ?                             [?]

% Determine Gaussian wind inflow profile (with uncertainty)
windInflowDistribution   = windDirection+windUncertainty;
weightsInflowUncertainty = gaussianWindDistribution(windInflowDistribution);
 
% Initialize GT-theory matrices    
[Pdir,DELdir,PDELdir]                                 = deal(zeros(1,1));
[Pdirall,Pdirbaseall,Pnombaseall]                     = deal(zeros(iterations,1));
[DELdirall,DELdirbaseall,DELnombaseall]               = deal(zeros(iterations,1));
[PDELdirall,PDELdirbaseall,PDELtotnom,PDELnombaseall] = deal(zeros(iterations,1));

yaw     = zeros(N,1);           % Initialize yaw matrix         [radians]
yawall  = zeros(iterations,N);  % Initialize yawall matrix      [radians]
yawbase = yaw;


%% Non-optimized (baseline run, with uncertainty)
[store_Ptot, store_DELtot] = deal(zeros(1,length(windInflowDistribution)));
for jj = 1:length(windInflowDistribution)
    windDir = windInflowDistribution(jj);
    
    for i = 1 : N % Find Turbine Positions w.r.t. Incoming Wind Direction
        Xt(i) = cos(-windDir)*Xc(i) + -sin(-windDir)*Yc(i); % Translated Xc-coordinates
        Yt(i) = sin(-windDir)*Xc(i) + cos(-windDir)*Yc(i);  % Translated Yc-coordinates
    end

    % Find front (most upwind) turbine:  
    Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
    NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

    X = NewPos(:,1);                    % Extracting the X-coordinates
    Y = NewPos(:,2);                    % Extracting the Y-coordinates
    X = X - min(X);                     % Discarding non-used X
    Y = Y - min(Y);                     % Discarding non-used Y
    
    % Power and loads
    [ P,Ptot,~,Dw,Ut,yw,Dwn,Up,I,~,~,Ic] = FLORIS_GT_test(windSpeed,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
    [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
    store_Ptot(1,jj)   = Ptot;
    store_DELtot(1,jj) = DELtot;
    
    % Check for nominal case
    if windDir == windDirection
        [Pnom(1),  Pnombase,   Pnombaseall(1)]    = deal(Ptot);
        [DELnom(1), DELnombase, DELnombaseall(1)] = deal(DELtot);
    end;
end
sum_Ptot   = store_Ptot  * weightsInflowUncertainty;
sum_DELtot = store_DELtot* weightsInflowUncertainty;

Pdir(1)                 = sum_Ptot;
Pdirall(1)              = sum_Ptot;
Pdirbase                = sum_Ptot;
Pdirbaseall(1)          = sum_Ptot;

DELdir(1)               = sum_DELtot;
DELdirall(1)            = sum_DELtot;
DELdirbase              = sum_DELtot;
DELdirbaseall(1)        = sum_DELtot;

PDELdir(1)              = 1-optConst*1;
PDELdirall(1)           = 1-optConst*1;
PDELdirbase             = 1-optConst*1; 
PDELdirbaseall(1)       = 1-optConst*1; 
PDELnom(1)              = 1-optConst*1;
PDELnombase             = 1-optConst*1;
PDELnombaseall(1)       = 1-optConst*1;


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
        yawall(k,i) = yaw(i);   % Remember yaw setting           [radians]
    end

    Ptot = 0;                       % Reset Total Power             [W]
    DELtot = 0;                     % Reset DEL                     [-]

    for jj = 1:length(windInflowDistribution)
        windDir = windInflowDistribution(jj);
        %% Find Turbine Positions w.r.t. Incoming Wind Direction
        % Find down-/crosswind turbine coordinates
        for i = 1 : N
        Xt(i) = cos(-windDir)*Xc(i) + -sin(-windDir)*Yc(i); % Translated Xc-coordinates
        Yt(i) = sin(-windDir)*Xc(i) + cos(-windDir)*Yc(i);  % Translated Yc-coordinates
        end

        % Find front (most upwind) turbine:  
        Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
        NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

        X = NewPos(:,1);                    % Extracting the X-coordinates
        Y = NewPos(:,2);                    % Extracting the Y-coordinates

        X = X - min(X);                     % Discarding non-used X
        Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
        %% Calculate amount of Power and Load
        [ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,~,~,Ic] = FLORIS_GT_test(windSpeed,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
        [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
        store_Ptot(1,jj) = Ptot;
        store_DELtot(1,jj) = DELtot;
    end  
    
    sum_Ptot = store_Ptot*weightsInflowUncertainty;
    sum_DELtot = store_DELtot*weightsInflowUncertainty;
    sum_PDELtot = (sum_Ptot/Pdir(1))-optConst*(sum_DELtot/DELdir(1)); % Generate Power & Load total
    
    
    windDir = 0;
    %% Find Turbine Positions w.r.t. Incoming Wind Direction
    % Find down-/crosswind turbine coordinates
    for i = 1 : N
        Xt(i) = cos(-windDir)*Xc(i) + -sin(-windDir)*Yc(i); % Translated Xc-coordinates
        Yt(i) = sin(-windDir)*Xc(i) + cos(-windDir)*Yc(i);  % Translated Yc-coordinates
    end

        % Find front (most upwind) turbine:  
    Pos     = [rot90(Xt) rot90(Yt)];    % Set position matrix
    NewPos  = sortrows(Pos, 1);         % Sort the position matrix on the smallest Xt value

    X = NewPos(:,1);                    % Extracting the X-coordinates
    Y = NewPos(:,2);                    % Extracting the Y-coordinates

    X = X - min(X);                     % Discarding non-used X
    Y = Y - min(Y); %+.5*D;             % Discarding non-used Y
    
    [ P,Ptot,c,Dw,Ut,yw,Dwn,Up,I,~,~,Ic] = FLORIS_GT_test(windSpeed,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);
    [DELtot data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary);
    PDELtotnom = (Ptot/Pnom(1))-optConst*(DELtot/DELnom(1)); % Generate Power & Load total  

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
% [ P_zero,Ptot_zero,c,Dw,Ut,yw,Dwn,Up,I,Aol,~,Ic] = FLORIS_GT_test(U,yaw,rho,ai,lf,PP,A,m_e,k_e,a_d,b_d,k_d,M_U,a_U,b_U,X,Y);

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