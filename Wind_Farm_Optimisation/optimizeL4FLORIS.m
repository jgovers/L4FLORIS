function[yaw_opt,J_Pws_opt,J_DEL_opt,J_sum_opt] = optimizeL4FLORIS( simStruct, optimStruct, modelStruct )
if nargin <= 0
    simStruct.sim_name = 'NO_IPC_FINAL';
    simStruct.Dw3_vector = 129+25:25:200;   % Discretization of wake diameter of region 3
    simStruct.C2C_vector = -230:10:230;     % Discretization of Center 2 Center distance
    simStruct.Ueff_vector = [0.8 0.6];      % Discretization of effective wind velocity
    simStruct.maxYaw = +30*(pi/180);        % Largest  yaw angle [radians]
    simStruct.minYaw = -30*(pi/180);        % Smallest yaw angle [radians]
    simStruct.axInd  = 1/3*ones(9);         % Axial induction factors
    simStruct.windUncertainty = [-12:4:12]; % Additional wind disturbance range (symmetric)
end;
if nargin <= 1
    optimStruct.optConst   = 1;     % Weighting factor                                                  
    optimStruct.iterations = 100;   % Iterations  [-] 
%    optimStruct.alpha      = 0.5*1/optimStruct.iterations; % Sensitivity [-]
end;
if nargin <= 2
    modelStruct = floris_param_model( 'ben' );
    turbType    = floris_param_turbine('nrel5mw');

    site.LocIF =   [300,    100.0,  turbType.hub_height
                    300,    300.0,  turbType.hub_height
                    300,    500.0,  turbType.hub_height
                    1000,   100.0,  turbType.hub_height
                    1000,   300.0,  turbType.hub_height
                    1000,   500.0,  turbType.hub_height
                    1600,   100.0,  turbType.hub_height
                    1600,   300.0,  turbType.hub_height
                    1600,   500.0,  turbType.hub_height];
    
    % Atmospheric settings    
    site.uInfIf   = 10;       % x-direction flow speed inertial frame (m/s)
    site.vInfIf   = 0;        % y-direction flow speed inertial frame (m/s)
    site.rho      = 1.1716;   % Atmospheric air density (kg/m3)
end;

% Optimization parameters
optConst   = optimStruct.optConst;
iterations = optimStruct.iterations;
%alpha      = optimStruct.alpha;

% Simulation parameters
sim_name    = simStruct.sim_name;
Dw3_vector  = simStruct.Dw3_vector;  % Discretization of wake diameter of region 3
C2C_vector  = simStruct.C2C_vector;  % Discretization of Center 2 Center distance
Ueff_vector = simStruct.Ueff_vector; % Discretization of effective wind velocity

% Import model settings
D               = turbType.rotorDiameter;
input.a         = simStruct.axInd;
yawmin          = simStruct.minYaw;
yawmax          = simStruct.maxYaw;
windSpeed       = hypot(site.uInfIf,site.vInfIf);       % Static Wind Speed [m/s]
windDirection   = atand(site.vInfIf/site.uInfIf);       % Nominal wind direction
windUncertainty = simStruct.windUncertainty;            % Wind direction disturbances

% Derive remaining necessary parameters
N      = size(site.LocIF,1);
A      = 0.5*pi*(D/2)^2; 

% Load DEL tables
load(['Wind_Field_Generation\Outputs\',sim_name,'\Ueff\Ueff_matrix.mat'])
load(['FAST_Analysis\Outputs\',sim_name,'\DEL_and_SIM\DEL_summary_',num2str(sim_name),'.mat'])

% Determine Gaussian wind inflow profile (with uncertainty)
windInflowDistribution   = windDirection+windUncertainty;
weightsInflowUncertainty = gaussianWindDistribution(windInflowDistribution);
 
% Initialize empty GT-theory matrices    
[J_Pws_opt,J_sum_opt] = deal(-1e10);
J_DEL_opt             = 1e10;
yaw                   = zeros(N,1);           % Initialize yaw matrix         [radians]
yaw_opt               = zeros(iterations,N);  % Initialize yawall matrix      [radians]

% -------GAME THEORY---------%
for k = 1:iterations                % k is the number of iterations
    if(~rem(k*100/iterations,5)); disp([' ' num2str(k*100/iterations) '% completed.']); end;
    % For k == 1, do a baseline run, otherwise randomize yaw angles
    if k > 1                        
        for i = 1:N                 % For each WT
            R1 = rand();            % Random value between [0 1]
            E = 1-k/iterations;     % Sensitivity linearly related to iteration
            if R1 < E
                R2 = normrnd(0,35)*(pi/180);  % random value [0 10]      
                yaw(i) = max(min(yaw_opt(i)+R2,yawmax),yawmin);
            else
                yaw(i) = yaw_opt(k-1,i);   % Old yaw setting [radians]
            end;
        end;
    end;

    for jj = 1:length(windInflowDistribution)
        windDir = windInflowDistribution(jj);
        site.uInfIf = windSpeed*cosd(windDir);
        site.vInfIf = windSpeed*sind(windDir);
             
        input.yaw  = yaw;
        [turbines, wakes, wtRows] = run_floris(input,modelStruct,turbType,site);
        
        % Reformat new FLORIS model output to fit with old DEL lookup code
        P  = zeros(1,N);
        Ut = zeros(1,N);
        Y  = zeros(1,N);
        for turbi = 1:N
            P(turbi)  = turbines(turbi).power;
            Ut(turbi) = turbines(turbi).windSpeed;
            Y(turbi)  = turbines(turbi).LocWF(2);
        end;
        Ptot = sum(P);
        Dw = zeros(N,N,3);
        yw = zeros(N,N);
        Up = [];
        Dwn = [];
        for turbrow = 1:length(wtRows) % For all turbine rows
            for turbi = wtRows{turbrow} % for all turbines inside this row
                diam_tmp = wakes(turbi).diameters;
                yw(turbi,turbi) = turbines(turbi).LocWF(2);
                if abs(turbines(turbi).windSpeed-windSpeed) < 0.05 % upstream turbine
                    Up = [Up turbi];
                else
                    Dwn = [Dwn turbi];
                end;
                for wakezone = 1:3
                    Dw(turbi,wtRows{turbrow},wakezone) = wakes(turbi).wakeDiameterInit; % Initial wake diameters
                    for dwrow = turbrow+1:length(wtRows) % for each downstream row of turbines...
                        Dw(turbi,wtRows{dwrow},wakezone)   = diam_tmp(dwrow-turbrow,wakezone);
                        yw(turbi,wtRows{dwrow}) = wakes(turbi).centerLine(2,dwrow-turbrow);
                    end;
                end;
            end;
        end;
        for wakezone = 1:3; Dw(:,:,wakezone) = triu(Dw(:,:,wakezone),0); end;
        
        % Find the most upstream turbine for each dwn turbine and write to I
        I = Up(1)*ones(1,length(Dwn)); % Set default choice for upw turbine
        for turbi = Up
            totOLareaRel = sum(wakes(turbi).OverlapAreaRel,2);
            mostOL = find(totOLareaRel==max(totOLareaRel)); % find indices of dwn turbines
            for dwn_i = 1:length(mostOL)
                I(find(Dwn==mostOL(dwn_i))) = turbi;
            end;
        end;
        
        % Ic defines for each dwn turbine what is the turbine affecting it most
        Ic = zeros(size(Dwn));
        for turbi = 1:length(Dwn)
            Ic(turbi) = turbines(Dwn(turbi)).turbLargestImpact;
        end;
        
        % Dw: wakes(1).diameters = 9x3, wakes(2).diameters = 8x3, .. (effect of column turb on row turb).
        % P: turbines(1).power, turbines(2).power, turbines(3).power, ...
        % Ut: mean speed at each wind turbine: turbines(1).windSpeed, ...
        % yw: wakes(1).centerLine, wakes(2).centerLine, ...
        % Up,Dwn: All upwind/downwind turbines
        % I: Furthest upstream turbine
        % Ic: most important upstream turbine
        [DELtot, data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary,D,windSpeed,Dw3_vector,C2C_vector,Ueff_vector,sim_name);
        
        if k==1
            Pbaseline   = Ptot;
            DELbaseline = DELtot;
        end;
        
        Ptot_inflows(1,jj)   = Ptot;   % results for each wind direction
        DELtot_inflows(1,jj) = DELtot; % results for each wind direction
    end;
 
    sum_Ptot    = Ptot_inflows   * weightsInflowUncertainty;  % Inflow uncertainty-weighed generated power
    sum_DELtot  = DELtot_inflows * weightsInflowUncertainty;  % Inflow uncertainty-weighed turbine DEL values
    sum_PDELtot = sum_Ptot/Pbaseline - optConst*sum_DELtot/DELbaseline; % Generate combined power and loads cost function
    
    %if (sum_Ptot > J_Pws_opt && sum_PDELtot > J_sum_opt)  % This line enforces that powers do not decrease because of this optimization
    if (sum_PDELtot > J_sum_opt) 
        yaw_opt(k,:) = yaw;         
        J_Pws_opt(k) = sum_Ptot; 
        J_DEL_opt(k) = sum_DELtot;
        J_sum_opt(k) = sum_PDELtot;
    else % if no improvements: keep optimal solution
        yaw_opt(k,:) = yaw_opt(k-1,:); 
        J_Pws_opt(k) = J_Pws_opt(k-1); 
        J_DEL_opt(k) = J_DEL_opt(k-1);
        J_sum_opt(k) = J_sum_opt(k-1);
    end;
end;

%% FIGURE BUILDING
figure
plot(J_sum_opt,'Linewidth',2)
grid on
title('Mixed optimization: Power & Load')
ylabel('PL-score [-]')
xlabel('Iterations [-]')

%%
figure
plot(J_Pws_opt/1E6,'Linewidth',2)
grid on
title('Power increase')
ylabel('Power [MW]')
xlabel('Iterations [-]')

%%
figure
plot(J_DEL_opt/1E6,'Linewidth',2)
grid on
title('Load decrease')
ylabel('DEL (10^6)')
xlabel('Iterations [-]')

% evaluate nominal wind direction, optimal settings, and plot output
site.uInfIf      = windSpeed*cosd(windDirection);
site.vInfIf      = windSpeed*sind(windDirection);
plots.plotLayout = false ; % plot farm layout w.r.t. inertial and wind frame
plots.plot2DFlow = true  ; % 2DflowFieldvisualisation in wind-aligned frame
plots.plot3DFlow = false ; % 3DflowFieldvisualisation in wind-aligned frametimer.script = tic;
run_floris(input,modelStruct,turbType,site,plots);
end