% Example: Controller design for NREL 5MW Model wind turbine
% J.W. van Wingerden (j.w.vanwingerden@tudelft.nl)
close all, clear, clc;
addpath subfunctions
% note x is for aft  y is sideways
%% some settings (limits)
Pitch_max       =       90;  % max pitch angle in deg
Pitch_min       =       -2;  % min pitch angle in deg
Pitch_max_rate  =        8;  % max pitch rate angle in deg/s
Pitch_min_rate  =       -8;  % min pitch rate angle in deg/s
Pitch_fine      =       0.106*2*pi/360;
Torque_limit    =       43100;  % Torque limit
Torque_slew_rate=       20000;

%% Torque speed curve
omega_A         =       400; % speed in RPM
omega_B         =       435; % speed in RPM
omega_C         =       1150; % speed in RPM
omega_D         =       1173; % speed in RPM
Demanded_torque =       43093; % demanded torque
Mode_gain       =       2.33229; % optimal mode gain

points=0:omega_C/1000/60*2*pi:omega_D/60*2*pi*1.1;

for i=1:1:length(points)
    if points(i)<omega_A/60*2*pi
        Torque_Table(i)=0;
    elseif points(i)<omega_B/60*2*pi
        Torque_Table(i)=(omega_B/60*2*pi)^2*Mode_gain/((omega_B-omega_A)/60*2*pi)*(points(i)-omega_A/60*2*pi);
    elseif points(i)<omega_C/60*2*pi
        Torque_Table(i)=points(i)^2*Mode_gain;
    elseif points(i)<omega_D/60*2*pi
        Torque_Table(i)=(Demanded_torque-(omega_C/60*2*pi)^2*Mode_gain)/((omega_D-omega_C)/60*2*pi)*(points(i)-omega_C*2*pi/60)+(omega_C/60*2*pi)^2*Mode_gain;
    else
        Torque_Table(i)=Demanded_torque;
    end
end

 

%% Other parameters
DT             =       0.0125; % sampling time (do not change)
%D               =       126;  % rotordiameter
%H               =       95;   % hub height
%Vnom            =       11.45; % Nominal wind speed
w               =       logspace(-3,2,10000)*2*pi;  %frequency grid

%% load linearized data 
load FASTTOOL_linearized;

% create continuous model from linearized state-space matrices
for i=1:1:length(sysm)
    SYSTURB.A(:,:,i)=sysm{i}.A;
    SYSTURB.B(:,:,i)=sysm{i}.B;
    SYSTURB.C(:,:,i)=sysm{i}.C;
    SYSTURB.D(:,:,i)=sysm{i}.D;
end
wtg = ss(SYSTURB.A,SYSTURB.B,SYSTURB.C,SYSTURB.D, 'inputname',sysm{1}.inputname,'outputname',sysm{1}.outputname, 'statename',sysm{1}.statename);
% convert GenSpeed to Rad/s
wtg=wtg([33 10 11],:) ;
wtg.C(1,:)=wtg.C(1,:)./60*2*pi;
wtg.outputname{1}='Row  33 = GenSpeed   (rad/s)';
wtg=wtg([1 2 3],[3 2 1]);


% design lowpass filter (to remove high frequent dynamics)
omegan=12.1/60*2*pi;
notch=tf([1 2*omegan*0.01 omegan^2],[1 2*omegan*0.5 omegan^2]);

LP = series(zpk([],-3,3),notch);                                      %1st order
omega=3; LPP=tf([omega^2],[1 2*omega*0.5 omega^2]);     % second order
% discretize the lowpass filter (for implementation reasons)
dLP = ss(c2d(LP,DT));
dLPP = ss(c2d(LPP,DT));

%% PITCH: design gain-scheduled PI pitch controller for wind speeds 12...25m/s
Ti = 1e-1.*ones(1,14);                    % integration constant
P1 = minreal(wtg(1,[1 2],8:21));
Kp = -1./(squeeze(abs(freqresp(P1(:,2,:),0.1*2*pi))))';
%-1e-3.*exp(linspace(0.5,1.5,14));  % now it is not gain scheduled
for i = 1:14
    PIpitch(:,:,i) = zpk(-Ti(i),0,Kp(i));
end
% figure, bode(-LP*PIpitch,w);   % bode plot of the controller (filter + PI)

% select the above rated wind speeds and the pitch and wind as inputs and speed as output


% create open-loop system
OL1 = series(append(1,LP*PIpitch),[P1; [0 tf([1 0],1)]]);  % create the Open loop

% check stability using the gain (> 2) and phase (> 45deg) margins
%figure, bode(OL1(1,2,:),w); hold on
%  bode(OL1(1,2,:),w,'r'); hold on
 [Gm,Pm] = margin(OL1(1,2,:));

% create closed-loop system
CL1 = feedback(OL1,1,2,1,-1);

% check the performance (overshoot < 2 rad/sec) with wind gust from IEC 61400-1
t = 0:0.005:10.5;
vgust = 1; %0.33*(0.11*Vnom/(1+0.1*(0.7*H/D)));
v = -0.37*vgust.*sin(3*pi.*t./10.5).*(1-cos(2*pi.*t./10.5))+0.4;
t = 0:0.005:50;
u = zeros(1,length(t))+0.4;
u(1:length(v)) = v;
% figure, lsim(CL1(1,1,:),u,t); hold on
% lsim(OL1(1,1,:),u,t);
% hold on, plot(t,2*ones(1,length(t)),'r'); hold off;
% hold on, plot(t,-2*ones(1,length(t)),'r'); hold off;

% values for gain-scheduling (needed for bladed)
PTi = [Ti(1) Ti];
PKp = [Kp(1) Kp];
PA = Lin.Pitch(7:21); % steady state values of the pitch angle


%% TORQUE: design gain-scheduled PI torque controller for wind speeds 5...11m/s
Ti = 0.25.*ones(1,14);
Kp = -3.5e3.*ones(1,14);
LPP=LPP;
for i = 1:11
    PItorque(:,:,i) = zpk(-Ti(i),0,Kp(i));
end
% figure, bode(-LPP*PItorque,w);

% creating notches

% select the below rated wind speeds and the torque and wind as inputs and speed as output
P = minreal(wtg(1,[1 3],10));

% create open-loop system
OL = series(append(1,LPP*PItorque),[P; [0 1]]);

% check stability using the gain (> 2) and phase (> 45deg) margins
% figure, bode(OL(1,2,:),w);
% [Gm,Pm] = margin(OL(1,2,:))

% create closed-loop system
CL = feedback(OL,1,2,1,-1);
CLt= feedback(P(1,2),LP*PItorque,1,1,-1);
% check the performance with step response
% figure, step(0.5*CL(1,1,:)/2/pi*60);
% hold on, plot(t,4*ones(1,length(t)),'r'); hold off;
% hold on, plot(t,-4*ones(1,length(t)),'r'); hold off;

Kpp=Kp(1); Kii=Ti(1)*Kp(1);

%% Damping enhancement fore-aft
% select the wind speeds
P3 = minreal(wtg(2:3,2:3,7:1:21));
Gainn=0.0;
Controller_foraft=-tf([1],[1 0])*Gainn;
OL_fore_aft= P3(1,1)*Controller_foraft;
% figure;bode(OL_fore_aft,w)

% [Gm,Pm] = margin(OL_fore_aft)

% create closed-loop system
CL=feedback(P3(1,1),Controller_foraft,1,1,-1);

% figure
% bode(P3(1,1),w);
% hold on
% bode(CL(1,1),w);
%% IPC control
% Inverse notch filter 1P
k_1p        = 1E-3;        %Scaling Gain
zeta_1p     = 0.5;          %Damping
omega_1p    = (2*pi)/4.95;  %Frequency [rad/s] (~0.2 Hz)
ki_1p       = 0.01;         %Integral gain
% Low-pass filter
omega_L     = 10;           %Frequency [rad/s] (~1.6 Hz)
zeta_L      = 1;            %Damping
% Inverse notch filter 2P
k_2p        = 1E-3;        %Scaling gain
zeta_2p     = 0.3;          %Damping
omega_2p    = (4*pi)/4.95;  %Frequency [rad/s] (~0.4 Hz)
ki_2p       = 0.002;        %Integral gain
% Reverse coleman transformation
delta_1p    = (25*pi)/180;  %Phase offset 1P
delta_2p    = (33*pi)/180;  %Phase offset 2P
% Pitch angle saturation for IPC
IPC_Pitch_max = 5;
IPC_Pitch_min = -5;