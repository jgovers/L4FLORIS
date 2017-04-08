clear all; close all; clc;
addpath ..\bin

% Set up settings
T               = 276;          % Simulation duration [seconds]
u_mean          = 8.0;          % Freestream wind speed [m/s]
dt              = 0.125;        % Timestep for FAST simulations
Gaussian_A      = 5;            % Wake deficit in center [m/s]
Gaussian_omegay = 50;           % Spread for Gaussian wake shape
Gaussian_omegaz = 50;           % Spread for Gaussian wake shape
plotProfile     = true;         % Plot the inflow profiles (y,z)
HH              = 90.0;         % Hub height
inflowSetName   = 'onlyC2C';    % Destination folder name

% LUT coverage
zWake     = HH;          % Height of wake center
C2C_range = -200:20:200; % Range of center-to-center (wake-turbine) coverage for LUT 
% --- More stuff to add here ---


% Generate grid points
time  = [dt:dt:T];     % time
x     = u_mean*time;   % longitudinal dimension
y     = 300:-5:-300;   % lateral dimension (NOTE: MUST BE POSITIVE TO NEGATIVE)
z     = 0:5:200;       % vertical dimension
Nx    = length(x);     % Number of grid points x-
Ny    = length(y);     % Number of grid points y-
Nz    = length(z);     % Number of grid points z-
[Y,Z] = ndgrid(y,z);   % 2D grid points


% Make folder
mkdir(['inflowProfiles/' inflowSetName]);

% Generate 2D wind fields
% --- Need to add more loops for higher order LUT ---
for yWake = C2C_range % Lateral location of wake center
    wakeGrid = zeros(Ny,Nz); % Calculate wake deficit
    for dyi = 1:Ny
        dy = y(dyi)-yWake;
        for dzi = 1:Nz
            dz = z(dzi)-zWake;
            wakeGrid(dyi,dzi) = Gaussian_A * exp(-(  ((dy.^2)/(2*Gaussian_omegay^2) + (dz.^2)/(2*Gaussian_omegaz^2))  ));
            % https://en.wikipedia.org/wiki/Gaussian_function#Two-dimensional_Gaussian_function
        end;
    end;
    % Plot inflow profile (m/s)
    u_waked = u_mean*ones(Ny,Nz)-wakeGrid; % maybe add round(..,N)?
    
    if plotProfile
        clf; contourf(Y,Z,u_waked);
        axis equal; xlabel('y (m)'); ylabel('z (m)'); title('Inflow profile (m/s)');
        colorbar; zlabel('Velocity (m/s)'); hold on;
        plot(0,zWake,'r+');
        drawnow;
    end;
    
    % Copy and add turbulence to the slices
    TI = 0.0; % Currently 0. We have to think about time sampling and TI...
    [u_out,v_out,w_out] = deal(zeros(Nx,Ny,Nz));
    for i = 1:Nx
        u_out(i,:,:) = u_waked+u_waked*(TI*randn);
    end;
    
    % Save to external files for FAST usage (.wnd)
    % --- filename needs to be extended according to added dimensions to LUT ---
    filename = ['inflowProfiles/' inflowSetName '/Inflow_C2C' num2str(yWake) '_TI'  num2str(TI)];
    writebladed(filename,(u_out-u_mean)/u_mean,v_out,w_out,x,y,z,u_mean);
    fid = fopen([filename, '.sum'], 'wt'); % Write .sum file
    fprintf(fid, 'T\tCLOCKWISE\n');
    fprintf(fid, '%0.0f\tHUB HEIGHT\n\n', HH);
    fprintf(fid, '%0.3f\tUBAR\n', u_mean);
    fprintf(fid, '%0.3f\tTI(u)\n', 100);
    fprintf(fid, '%0.3f\tTI(v)\n', 100);
    fprintf(fid, '%0.3f\tTI(w)\n\n', 100);
    fprintf(fid, '0\tHEIGHT OFFSET');
    fclose(fid);
end;

% Save workspace for future use
save(['inflowProfiles/' inflowSetName '/workspace.mat']);