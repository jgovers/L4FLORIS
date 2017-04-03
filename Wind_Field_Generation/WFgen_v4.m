%% Generation of wind fields with .wnd & .sum extension.
% Code written by Ben Wilson, student at TU-Delft
global D U T dt
global Dw3_vector C2C_vector Ueff_vector sim_name


% Input
Ubase = U;                                 % Wind speed [m/s]
D = 129;                                    % Rotor diameter        [m]
R1 = D/2;                                   % Rotor Radius          [m] 
H = 90;                                     % Hub height            [m]
z0 = 0.002;                                 % Roughness length      [m]
A = pi*(D/2)^2;                             % Rotor surface         [m^2]
yaw = 0;                                    % No yaw error          [-]

Ly = 600;                                  % y-width               [m]
Lz = 200;                                   % z-height              [m]
Ny = 60;                                    % grid points           [-]
Nz = 20;                                    % grid points           [-]    

ai   = 1/3;                 % Axial Induction Factor        [-]
k_e  = 0.065;               % Gebraad                       [-]
m_e  = [-0.5 0.22 1];       % Gebraad                       [-]
a_U  = 5;                   % Gebraad                       [-]
b_U  = 1.66;                % Gebraad                       [-]
M_U  = [0.5 1 5.5];         % Gebraad                       [-]

Ueff_matrix = zeros(length(C2C_vector),length(Dw3_vector), length(Ueff_vector)); 

mkdir('Outputs',sim_name)
mkdir(strcat('Outputs\',num2str(sim_name)),'Images')
mkdir(strcat('Outputs\',num2str(sim_name)),'Mat')
mkdir(strcat('Outputs\',num2str(sim_name)),'WindFiles')
mkdir(strcat('Outputs\',num2str(sim_name)),'Ueff')
addpath('Outputs')

for Ueff_vector_step = 1:length(Ueff_vector)
    U = Ubase*Ueff_vector(Ueff_vector_step);
    % Simulate values for 25*D = 3225 [m]
    % - m_U(q),c(q,d),u_wake_mat(q,d),wsd(q,d),R2_mat(q,d),D2_mat(q,d)
    dwn_d_vector = linspace(0,3225,3226); % 
    for dwn_d_step = 1:length(dwn_d_vector)
        dwn_d  = dwn_d_vector(dwn_d_step);
        for q = 1:3 
            % Wake decay parameter per region
            m_U(q)                  = M_U(q)/cosd(a_U + b_U*yaw*(180/pi));
            % Wake decay coefficient per region per distance
            c(q,dwn_d_step)         = (D/(D + 2*k_e*m_U(q)*(dwn_d)))^2; 
            % Wake velocity per region per distance
            V_wake_matrix(q,dwn_d_step)= U*(1-2*ai*c(q,dwn_d_step));    
            % Wake diameter per region per distance
            D2_mat(q,dwn_d_step)    =(max(D + 2*k_e*m_e(q)*dwn_d,0));
        end
    end
    
    % Find data corresponding data for given wake diameters
    d_dwn = zeros(length(Dw3_vector),1);
    for Dw3_vector_step = 1:length(Dw3_vector)
        % Find downwind distance corresponding to wake diameter
        ext = find(D2_mat(3,:) > Dw3_vector(Dw3_vector_step));    % dwn-wind distance                 [m]   
        d_dwn(Dw3_vector_step) = ext(1);                % Store dwn-wind distance in vector d_dwn
        % Corresponding region 2 diameter 
        Dw2_vector(Dw3_vector_step) = round(D2_mat(2,d_dwn(Dw3_vector_step)));
        % Corresponding region 1 diameter
        Dw1_vector(Dw3_vector_step) = round(D2_mat(1,d_dwn(Dw3_vector_step)));  
        for q =1:3
            % Wake decay coefficient corresponding to dwn-distance  
            c_vector(Dw3_vector_step,q) = c(q,d_dwn(Dw3_vector_step));
            % Wake velocity (per region) corresponding to dwn-distance
            V_wake(q,Dw3_vector_step) = V_wake_matrix(q,d_dwn(Dw3_vector_step)); 
        end
    end

    % Area of wake overlap for the downwind turbine
    % Per wake diameter, per C2C distance; an amount of overlap per wake region.
    Aol=zeros(length(C2C_vector),length(Dw3_vector),3);
    for Dw3_vector_step=1:length(Dw3_vector)
        Dw(1,2,3) = Dw3_vector(Dw3_vector_step);
        Dw(1,2,2) = Dw2_vector(Dw3_vector_step);
        Dw(1,2,1) = Dw1_vector(Dw3_vector_step);
        for C2C_vector_step = 1:length(C2C_vector)
           C2C = C2C_vector(C2C_vector_step);
            Aol(C2C_vector_step,Dw3_vector_step,1)=Overlap(C2C,Dw,0,0,1,2,1); % DOOR I EN J vast te zetten moeten er wel parameters worden verandert in het OVERLAP bestand
            Aol(C2C_vector_step,Dw3_vector_step,2)=Overlap(C2C,Dw,0,0,1,2,2);
            Aol(C2C_vector_step,Dw3_vector_step,3)=Overlap(C2C,Dw,0,0,1,2,3);
            Aol(C2C_vector_step,Dw3_vector_step,2)=Aol(C2C_vector_step,Dw3_vector_step,2)-Aol(C2C_vector_step,Dw3_vector_step,1);
            Aol(C2C_vector_step,Dw3_vector_step,3)=Aol(C2C_vector_step,Dw3_vector_step,3)-Aol(C2C_vector_step,Dw3_vector_step,2)-Aol(C2C_vector_step,Dw3_vector_step,1);
        end
    end    

    % Effective wind speed
    % Per wake diameter, per C2C distance; an effective wind speed.
    for Dw3_vector_step=1:length(Dw3_vector)
        for C2C_vector_step = 1:length(C2C_vector)
            Q = 0;
            G = 0;
            for q= 1:3
                G=G+c_vector(Dw3_vector_step,q)*min((Aol(C2C_vector_step,Dw3_vector_step,q)/A),1);
            end
            Q=Q+(ai*G)^2;
            Ueff(C2C_vector_step,Dw3_vector_step)= U*(1-2*sqrt(Q));
        end  
    end
    Ueff_matrix(1:length(C2C_vector),1:length(Dw3_vector),Ueff_vector_step) = Ueff(1:length(C2C_vector),1:length(Dw3_vector));

    %------------ Generate the wind field files and images -------------------%

    % Width check
    bound = ((R1+max(Dw3_vector))*2);
    if bound > Ly
        display('Wind field width is to small')
    end
    
    % Per given wake diameter
    for Dw3_vector_step=1:length(Dw3_vector)
        R2_3 = Dw3_vector(Dw3_vector_step)/2;
        R2_2 = Dw2_vector(Dw3_vector_step)/2;
        R2_1 = Dw1_vector(Dw3_vector_step)/2;
        % Per given C2C distance
        for C2C_vector_step=1:length(C2C_vector)
            C2C = C2C_vector(C2C_vector_step);

            % Velocity per wake region
            V_3 = V_wake(3,Dw3_vector_step);
            V_2 = V_wake(2,Dw3_vector_step);
            V_1 = V_wake(1,Dw3_vector_step);

            % Domain
            %%
            x = (dt:dt:T)*U;
            y = linspace(Ly/2, -Ly/2, Ny+1);              % y = 0 - middlepoint   [m] +0.5
            z = linspace(0, Lz, Nz+1);                    % hh - middlepoint      [m] +0.5
            [X, Y, Z] = ndgrid(x, y, z);                % build grid            [-]
%             [Y, Z] = meshgrid(y,z);
%%

            % Generate the u-matrices
            u_c = zeros((T/dt),length(y),length(z)); % Initialize wind speed field

            % Wake region surface (filled in u-matrix)
            u_circ3 = sqrt((Y+C2C).^2+(Z-H).^2)<=R2_3;   % Circle with R3    [m^2] 
            u_circ2 = sqrt((Y+C2C).^2+(Z-H).^2)<=R2_2;   % Circle with R2    [m^2]
            u_circ1 = sqrt((Y+C2C).^2+(Z-H).^2)<=R2_1;   % Circle with R1    [m^2]
            u_reg3 = u_circ3 - u_circ2;                 % Region 3          [m^2]
            u_reg2 = u_circ2 - u_circ1;                 % Region 2          [m^2]
            u_reg1 = u_circ1;                           % Region 1          [m^2]  

            % Generate a basis for the wind field
            u_c(1,:,:) = ones(length(y),length(z));     % WF: grid 1 m/s
            % u_c = real(U*log(Z/z0)/log(H/z0));        % WF: log-profile

            %Repeat for entire timelength
            for i = 1:(T/dt)
                u_c(i,:,:) = u_c(1,:,:);
            end

            % Generate velocity field    
            u = U*u_c-u_reg3*(U-V_3)-u_reg2*(U-V_2)-u_reg1*(U-V_1);  % u-direction: perpedicular to rotor plane    [m/s] 

            v = 0*u;                                % ommit
            w = 0*u;                                % ommit
            %% Outputs
            % Z(1) = 0 [m] etc
            % Generate JPG-image
            filename1=strcat('Outputs\',num2str(sim_name),'\Images\WF_image','_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step),'.jpg');
            
            zgridstep = Lz/Nz; % size of grid step [m]
            ygridstep = Ly/Ny; % size of grid step [m]
            
            % Plot surface on lower level for plot on top
            figure('Position', [100 100 1100 500])
            h = surface(squeeze(u(1,:,:)));
%             z = get(h,'ZData');
%             set(h,'ZData',z-10)  
%             
%             hold on
%             
%             % Plot downwind turbine-shadow
%             k = 0;
%             for theta = 0:pi/100:2*pi
%                 k = k+1;
%                 xc(k) = (129/2)/zgridstep*cos(theta)+(90/zgridstep)+1;          %Check die + 1
%                 yc(k) = (129/2)/zgridstep*sin(theta)+((Ly/2)/ygridstep)+1;      %Check die + 1
%             end
%             plot(xc,yc,'--','LineWidth',4);
%             
%             xt  = [1 (90/zgridstep)+1];
%             yt  = [(Ly/2)/ygridstep+1 (Ly/2)/ygridstep+1];
%             plot(xt,yt,'b','LineWidth',4)
       

            title('Wind velocity profile'); 
            xlabel('Height [m]'); 
            ylabel('Width [m]');
            set(gca, 'XAxisLocation', 'top')
            
            set(gca, 'xtick', [1:zgridstep:Nz+1],'xticklabel',[0:zgridstep*Lz/Nz:Lz])
            set(gca, 'ytick', [1:10:Ny+1],'yticklabel',[Ly/2:-10*ygridstep:-Ly/2])
            cTick1 = V_1; cTick2 = V_2; cTick3 = V_3; cTick4 = U;
            colorbar('Ticks',[cTick1 cTick2 cTick3 cTick4]); 
            [A,B] = size(y);
            colormap(hot)
%             set(h,'edgecolor','none');
            camroll(90)
            xlim([1 Nz+1]);                   % 1 = 0 [m]
            ylim([1 Ny+1]);                   % 1 = 0 [m]
            axis tight
            
            im = getframe(gcf);
            im = imresize(im.cdata, [640 1600]);      
            imwrite (im, filename1, 'jpg');
%
            % Generate MAT-file
            filename2=strcat('Outputs\',num2str(sim_name),'\Mat\WF_slice','_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step));
            save(filename2,'u')

            filename3=strcat('Outputs\',num2str(sim_name),'\WindFiles\WF_field','_',num2str(Dw3_vector_step),'_c2c_',num2str(C2C_vector_step),'_Ueff_',num2str(Ueff_vector_step));
            % Write .wnd file
            writebladed(filename3,(u-U)/U,v/U,w/U,x,y,z,U)
            % Write .sum file
            fid = fopen([filename3, '.sum'], 'wt');
            fprintf(fid, 'T\tCLOCKWISE\n');
            fprintf(fid, '%0.0f\tHUB HEIGHT\n\n', H);
            fprintf(fid, '%0.3f\tUBAR\n', U);
            fprintf(fid, '%0.3f\tTI(u)\n', 100);
            fprintf(fid, '%0.3f\tTI(v)\n', 100);
            fprintf(fid, '%0.3f\tTI(w)\n\n', 100);
            fprintf(fid, '0\tHEIGHT OFFSET');
            fclose(fid);
            close all;
        end
    end
end
% Save matrix for look-up use
save('Ueff_matrix','Ueff_matrix');
name1 = strcat('Outputs\',num2str(sim_name),'\Ueff');
movefile('Ueff_matrix.mat',name1)

clearvars -except a_choice b_choice c_choice d_choice Dw3_vector C2C_vector Ueff_vector sim_name N U D T dt