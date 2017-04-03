% This script reads FAST *.fst files and creates Matlab workspace variables
% required to run the FAST s-function in Simulink.
% Modified by Hazim Namik on 18/9/2007 to read the number of active DOF

% ----------------------- Modification begins ----------------------- 
noActiveDOF = 0; 
activeDOFList = {};
% ----------------------- Modification ends ----------------------- 

input_len=size(input_fast,2); % the S-function needs this parameter
fid=fopen(input_fast);
if (fid == -1)
    disp(['Input file:  ',input_fast,' could not be opened.']);
    return
end

for i=1:2;
    temp_char=fgetl(fid); % first two lines
end
FTitle=fgetl(fid); % input file description
disp(FTitle)

for i=1:5;
    temp_char=fgetl(fid); % through AnalMode
end

 
% read simulation parameters
NumBl=fscanf(fid,'%i',[1 1]); temp_char=fgetl(fid); % the S-function needs this parameter
TMax = fscanf(fid,'%g',[1 1]); temp_char = fgetl (fid); % can be used in Simulation Parameters menu
DT = fscanf(fid, '%g', [1 1]); temp_char = fgetl (fid); % can be used in Simulation Parameters menu

% ----------------------- Modification begins ----------------------- 
for i=1:43;
    temp_char = fgetl (fid); % Turbine control through feature switches
end

for i = 1:11
    temp_char = fgetl (fid);
    temp_char2 = strread(temp_char,'%s',2);
    if(strcmp(temp_char2{1},'True'))
        noActiveDOF = noActiveDOF+1;
        activeDOFList(noActiveDOF,1) = temp_char2(2);
    end
end

for i = 1:3
    temp_char = fgetl (fid);    
end
% ----------------------- Modification ends ----------------------- 

% read initial conditions
OoPDefl = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
IPDefl = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
TeetDefl = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
Azimuth = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
RotSpeed = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
NacYaw = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
TTDspFA = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
TTDspSS = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);


% read AzimB1Up
for i=1:18;
    temp_char = fgetl (fid); % Turbine configuration through cone angles
end
AzimB1Up = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid); % Azimuth when Blade 1 is up

for i=1:35;
    temp_char = fgetl (fid); % Mass and inertia to beginning of Platform Model
end

% if we have a platform model, read initial platform displacements
PtfmModel = fscanf (fid, '%g', [1 1]); temp_char = fgetl (fid);
if ((PtfmModel == 1) | (PtfmModel == 2) | (PtfmModel == 3))
   temp_char = fgetl (fid); 
   i=2;n=1;
   while temp_char(i)~='"' 
      PtfmFile(n) = temp_char(i);
      i=i+1;
      n=n+1;
   end
   fid2=fopen(PtfmFile);
   if (fid2 == -1)
      disp(['Platform file:  ',PtfmFile,' could not be opened.']);
      return
   end
   % ----------------------- Modification begins -----------------------
   for i=1:4;
      temp_char = fgetl (fid2); % first 4 lines of PtfmFile
   end
   for i = 1:6
       temp_char = fgetl (fid2);
       temp_char2 = strread(temp_char,'%s',2);
       if(strcmp(temp_char2{1},'True'))
           noActiveDOF = noActiveDOF+1;
           activeDOFList(noActiveDOF,1) = temp_char2(2);
       end
   end
   temp_char = fgetl (fid2);
   % ----------------------- Modification ends -----------------------
   PtfmSurge = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial platform surge
   PtfmSway = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial platform sway
   PtfmHeave = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial platform heave
   PtfmRoll = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial platform roll
   PtfmPitch = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial platform pitch
   PtfmYaw = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial platform yaw
   status = fclose(fid2);
else
   temp_char = fgetl(fid); % read PtfmFile line
end

for i=1:8;
   temp_char = fgetl (fid); % Nacelle-Yaw to beginning of Furling
end

% if furling, read initial rotor and tail furl values
Furling = fgetl (fid); 
if ((Furling(1) == 't') | (Furling(1) == 'T'))
   temp_char = fgetl (fid); 
   i=2;n=1;
   while temp_char(i)~='"' 
      FurlFile(n) = temp_char(i);
      i=i+1;
      n=n+1;
   end
   fid2=fopen(FurlFile);
   if (fid2 == -1)
      disp(['Furling file:  ',FurlFile,' could not be opened.']);
      return
   end
   for i=1:7;
      temp_char = fgetl (fid2); % first 7 lines of FurlFile
   end
   RotFurl = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial rotor furl
   TailFurl = fscanf (fid2, '%g', [1 1]); temp_char = fgetl (fid2); % Initial tail furl
   status = fclose(fid2);
else
   temp_char = fgetl(fid); % read FurlFile line
end

for i=1:42;
    temp_char = fgetl (fid); % Rotor-Teeter to beginning of OutList
end

% read output list 
k=1;n=1;i=2;
temp_char = fgetl (fid); 
while temp_char(1) ~= 'E' % the first character should always be " or blank line
   while temp_char(i)~='"' 
       if temp_char(i) == ' '
           i=i+1;
       else
          temp(n)=temp_char(i);
          n=n+1;
          i=i+1;
      end
       if (temp_char(i) == ',')
           if exist('temp')
            OutList(k,1)=cellstr(temp);
            k=k+1;
            clear temp;
           end
           n=1;
           i=i+1;
       end
   end
   if exist('temp')
    OutList(k,1)=cellstr(temp);
    k=k+1;
    clear temp;
   end
   n=1;
   i=2;
   clear temp_char;
   temp_char = fgetl(fid);
   if (isempty(temp_char))
      temp_char = fgetl(fid);
   end
end
NumOuts = k-1;  % the S-function needs this parameter 
status=fclose(fid);


% Set number of DOF's
if (NumBl == 2)
    NDOF = 22;
elseif (NumBl == 3 )
    NDOF = 24;
else
    disp ('NumBl must be 2 or 3')
end


% Set DOF indices
DOF_Sg   =  1;                 % DOF index for platform surge.
DOF_Sw   =  2;                 % DOF index for platform sway.
DOF_Hv   =  3;                 % DOF index for platform heave.
DOF_R    =  4;                 % DOF index for platform roll.
DOF_P    =  5;                 % DOF index for platform pitch.
DOF_Y    =  6;                 % DOF index for platform yaw.
DOF_TFA1 =  7;                 % DOF index for 1st tower fore-aft mode.
DOF_TSS1 =  8;                 % DOF index for 1st tower side-to-side mode.
DOF_TFA2 =  9;                 % DOF index for 2nd tower fore-aft mode.
DOF_TSS2 = 10;                 % DOF index for 2nd tower side-to-side mode.
DOF_Yaw  = 11;                 % DOF index for nacelle-yaw.
DOF_RFrl = 12;                 % DOF index for rotor-furl.
DOF_GeAz = 13;                 % DOF index for the generator azimuth.
DOF_DrTr = 14;                 % DOF index for drivetrain rotational-flexibility.
DOF_TFrl = 15;                 % DOF index for tail-furl.
for k = 1:NumBl % Loop through all blades
   DOF_BF(k,1) = 16 + 3*(k-1); % 1st blade flap mode--DOFs 16, 19, and 22 for blade 1, 2, and 3, respectively
   DOF_BE(k,1) = 17 + 3*(k-1); % 1st blade edge mode--DOFs 17, 20, and 23 for blade 1, 2, and 3, respectively
   DOF_BF(k,2) = 18 + 3*(k-1); % 2nd blade flap mode--DOFs 18, 21, and 24 for blade 1, 2, and 3, respectively
end             % k - All blades
DOF_Teet = 22;                 % DOF index for rotor-teeter.


% Create initial condition arrays in rad, rad/s
q_init(1:NDOF)=0;
qdot_init(1:NDOF)=0;


% Set all initial conditions except initial blade and tower displacements, which are very complicated equations.
if (NumBl == 2)
    q_init(DOF_Teet)=TeetDefl*pi/180;
end
if ((Furling(1) == 't') | (Furling(1) == 'T'))
    q_init(DOF_RFrl) = RotFurl*pi/180;
    q_init(DOF_TFrl) = TailFurl*pi/180;
end
if ((PtfmModel == 1) | (PtfmModel == 2) | (PtfmModel == 3))
    q_init(DOF_Sg  ) = PtfmSurge;
    q_init(DOF_Sw  ) = PtfmSway;
    q_init(DOF_Hv  ) = PtfmHeave;
    q_init(DOF_R   ) = PtfmRoll*pi/180;
    q_init(DOF_P   ) = PtfmPitch*pi/180;
    q_init(DOF_Y   ) = PtfmYaw*pi/180;
end

q_init(DOF_Yaw )=NacYaw*pi/180;
Azim_Initial = rem(Azimuth - AzimB1Up + 270.0 + 360.0, 360); % Internal position of blade 1.
q_init(DOF_GeAz)=Azim_Initial*pi/180;


qdot_init(DOF_GeAz)=RotSpeed*pi/30;

Initialized = 1; % Tells S-function if this script ran prior to simulation.  0 = no.

clear temp_char fid status temp k n i
clear AzimB1Up Azim_Initial FTitle 
clear PtfmModel PtfmFile PtfmSurge PtfmSway PtfmHeave PtfmRoll PtfmPitch PtfmYaw
clear Furling FurlFile RotFurl TailFurl fid2
clear OoPDefl IPDefl TeetDefl Azimuth RotSpeed NacYaw TTDspFA TTDspSS 


