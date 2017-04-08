function[] = TurbSim(U,H,alpha,T,dt,Ly,Lz,Ny,Nz,IEC,Type,TurbExe,OutDir)
% TurbSim(U,H,alpha,T,dt,Ly,Lz,Ny,Nz,IEC,Type,TurbExe,OutDir)
%   A script to call TurbSim and create a binary wind file "wind.wnd" in 
%   the directory OutDir.
% 
%   U       (double)    Mean hub height wind speed [m/s].
%   H       (double)    Hub height (must be > 0.5*Ly) [m].
%   alpha   (double)    Power law exponent [-].
%   T       (double)    Time series length [s].
%   dt      (double)    Time step [s].
%   Ly      (double)    Domain width [m].
%   Lz      (double)    Domain height (should be >= 2*(Rotor radius + shaft
%                       length) [m].
%   Ny      (integer)   Number of grid points in y-direction [-].
%   Nz      (integer)   Number of grid points in z-direction [-].
%   IEC     (string)    IEC class (e.g., '1A', '2B', '3C')
%   Type    (string)    Type of wind climate ('NTM'/'ETM'/'EWM1'/'EWM50')
%   TurbExe (string)    TurbSim location (e.g., 'C:\...\TurbSim.exe')
%   OutDir  (string)    Output directory (should be pointing towards the 
%                       folder containing the file <turbine>_AeroDyn.ipt; 
%                       e.g., 'C:\...\Wind Turbine Design\Turbine\')

%% Wind type
if ~strcmpi(Type,'NTM')
    Type = [IEC(1), Type];
end

%% Turbulence seed
rng('shuffle')
seed = randi([-2147483648, 2147483647]);

%% Write TurbSim input file
if ~strcmpi(OutDir(end), '\')
    OutDir = [OutDir, '\'];
end
fid = fopen([OutDir, 'wind.inp'], 'wt');
fprintf(fid, 'TurbSim Input File. Valid for TurbSim v1.06.00, 21-Sep-2012\n');
fprintf(fid, '\n');
fprintf(fid, '---------Runtime Options-----------------------------------\n');
fprintf(fid, '%i                  RandSeed1       - First random seed  (-2147483648 to 2147483647) \n', seed);
fprintf(fid, 'RANLUX              RandSeed2       - Second random seed (-2147483648 to 2147483647) for intrinsic pRNG, or an alternative pRNG: "RanLux" or "RNSNLW"\n');
fprintf(fid, 'False               WrBHHTP         - Output hub-height turbulence parameters in binary form?  (Generates RootName.bin)\n');
fprintf(fid, 'False               WrFHHTP         - Output hub-height turbulence parameters in formatted form?  (Generates RootName.dat)\n');
fprintf(fid, 'False               WrADHH          - Output hub-height time-series data in AeroDyn form?  (Generates RootName.hh)\n');
fprintf(fid, 'False               WrADFF          - Output full-field time-series data in TurbSim/AeroDyn form? (Generates Rootname.bts)\n');
fprintf(fid, 'True                WrBLFF          - Output full-field time-series data in BLADED/AeroDyn form?  (Generates RootName.wnd)\n');
fprintf(fid, 'False               WrADTWR         - Output tower time-series data? (Generates RootName.twr)\n');
fprintf(fid, 'False               WrFMTFF         - Output full-field time-series data in formatted (readable) form?  (Generates RootName.u, RootName.v, RootName.w)\n');
fprintf(fid, 'True                WrACT           - Output coherent turbulence time steps in AeroDyn form? (Generates RootName.cts)\n');
fprintf(fid, 'True                Clockwise       - Clockwise rotation looking downwind? (used only for full-field binary files - not necessary for AeroDyn)\n');
fprintf(fid, '0                   ScaleIEC        - Scale IEC turbulence models to exact target standard deviation? [0=no additional scaling; 1=use hub scale uniformly; 2=use individual scales]\n');
fprintf(fid, ' \n');
fprintf(fid, '--------Turbine/Model Specifications-----------------------\n');
fprintf(fid, '%i                  NumGrid_Z       - Vertical grid-point matrix dimension\n', Nz);
fprintf(fid, '%i                  NumGrid_Y       - Horizontal grid-point matrix dimension\n', Ny);
fprintf(fid, '%2.5f               TimeStep        - Time step [seconds]\n', dt);
fprintf(fid, '%2.3f               AnalysisTime    - Length of analysis time series [seconds] (program will add time if necessary: AnalysisTime = MAX(AnalysisTime, UsableTime+GridWidth/MeanHHWS) )\n', T);
fprintf(fid, '%2.3f               UsableTime      - Usable length of output time series [seconds] (program will add GridWidth/MeanHHWS seconds)\n', T);
fprintf(fid, '%2.3f               HubHt           - Hub height [m] (should be > 0.5*GridHeight)\n', H);
fprintf(fid, '%2.3f               GridHeight      - Grid height [m] \n', Lz);
fprintf(fid, '%2.3f               GridWidth       - Grid width [m] (should be >= 2*(RotorRadius+ShaftLength))\n', Ly);
fprintf(fid, '0                   VFlowAng        - Vertical mean flow (uptilt) angle [degrees]\n');
fprintf(fid, '0                   HFlowAng        - Horizontal mean flow (skew) angle [degrees]\n');
fprintf(fid, '  \n');
fprintf(fid, '--------Meteorological Boundary Conditions-------------------\n');
fprintf(fid, '"IECKAI"            TurbModel       - Turbulence model ("IECKAI"=Kaimal, "IECVKM"=von Karman, "GP_LLJ", "NWTCUP", "SMOOTH", "WF_UPW", "WF_07D", "WF_14D", "TIDAL", or "NONE")\n');
fprintf(fid, '"1-ED3"             IECstandard     - Number of IEC 61400-x standard (x=1,2, or 3 with optional 61400-1 edition number (i.e. "1-Ed2") )\n');
fprintf(fid, '"%s"                IECturbc        - IEC turbulence characteristic ("A", "B", "C" or the turbulence intensity in percent) ("KHTEST" option with NWTCUP model, not used for other models)\n', IEC(2));
fprintf(fid, '"%s"                IEC_WindType    - IEC turbulence type ("NTM"=normal, "xETM"=extreme turbulence, "xEWM1"=extreme 1-year wind, "xEWM50"=extreme 50-year wind, where x=wind turbine class 1, 2, or 3)\n', upper(Type));
fprintf(fid, 'default             ETMc            - IEC Extreme Turbulence Model "c" parameter [m/s]\n');
fprintf(fid, '"PL"                WindProfileType - Wind profile type ("JET";"LOG"=logarithmic;"PL"=power law;"H2L"=Log law for TIDAL spectral model;"IEC"=PL on rotor disk, LOG elsewhere; or "default")\n');
fprintf(fid, '%2.3f               RefHt           - Height of the reference wind speed [m]\n', H);
fprintf(fid, '%2.3f               URef            - Mean (total) wind speed at the reference height [m/s] (or "default" for JET wind profile)\n', U);
fprintf(fid, 'default             ZJetMax         - Jet height [m] (used only for JET wind profile, valid 70-490 m)\n');
fprintf(fid, '%2.3f               PLExp           - Power law exponent [-] (or "default")           \n', alpha);
fprintf(fid, 'default             Z0              - Surface roughness length [m] (or "default")\n');
fprintf(fid, '\n');
fprintf(fid, '--------Non-IEC Meteorological Boundary Conditions------------\n');
fprintf(fid, 'default             Latitude        - Site latitude [degrees] (or "default")\n');
fprintf(fid, '0.05                RICH_NO         - Gradient Richardson number \n');
fprintf(fid, 'default             UStar           - Friction or shear velocity [m/s] (or "default")\n');
fprintf(fid, 'default             ZI              - Mixing layer depth [m] (or "default")\n');
fprintf(fid, 'default             PC_UW           - Hub mean u''w'' Reynolds stress (or "default")\n');
fprintf(fid, 'default             PC_UV           - Hub mean u''v'' Reynolds stress (or "default")\n');
fprintf(fid, 'default             PC_VW           - Hub mean v''w'' Reynolds stress (or "default")\n');
fprintf(fid, 'default             IncDec1         - u-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
fprintf(fid, 'default             IncDec2         - v-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
fprintf(fid, 'default             IncDec3         - w-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
fprintf(fid, 'default             CohExp          - Coherence exponent (or "default")\n');
fprintf(fid, '\n');
fprintf(fid, '--------Coherent Turbulence Scaling Parameters-------------------\n');
fprintf(fid, '"dummy"             CTEventPath     - Name of the path where event data files are located\n');
fprintf(fid, '"Random"            CTEventFile     - Type of event files ("LES", "DNS", or "RANDOM")\n');
fprintf(fid, 'true                Randomize       - Randomize the disturbance scale and locations? (true/false)\n');
fprintf(fid, '1.0                 DistScl         - Disturbance scale (ratio of wave height to rotor disk). (Ignored when Randomize = true.)\n');
fprintf(fid, '0.5                 CTLy            - Fractional location of tower centerline from right (looking downwind) to left side of the dataset. (Ignored when Randomize = true.)\n');
fprintf(fid, '0.5                 CTLz            - Fractional location of hub height from the bottom of the dataset. (Ignored when Randomize = true.)\n');
fprintf(fid, '30.0                CTStartTime     - Minimum start time for coherent structures in RootName.cts [seconds]\n');
fprintf(fid, '\n');
fprintf(fid, '==================================================\n');
fprintf(fid, 'NOTE: Do not add or remove any lines in this file!\n');
fprintf(fid, '==================================================\n');
fclose(fid);

%% Call to TurbSim
if strcmpi(TurbExe(end-3:end), '.exe')
    TurbExe = TurbExe(1:end-4);
end
% system(['"', TurbExe, '" [/h] "', OutDir, 'wind.inp"']); % Console output
[~, ~] = system(['"', TurbExe, '" [/h] "', OutDir, 'wind.inp"']); % No console output
