function [ DEL_tot,DEL,D2_l,WS_l,O_l,D2_extract_total] = DEL_table(Up,Aol,U,Ut,I,Dw,num_DEL_iter,concatenated_result,rel_WT,Dwn)

    global N D                                  % Import N & D
    
    for i = 1:N
        % Upwind turbines!
        % Recieve nonwaked flow: No wake diameter, No overlap, No windspeed deficit. 
        if (i <= length(Up))
            D2_l(i) = 0;
            WS_l(i) = 0;
            O_l(i) = 0;
            run FindDEL_upwind
        end
        % Downwind turbines!
        % Recieve waked flow with a wake diameter, overlap and windspeed deficit.
        if (i > length(Up))
            o_sum = 0;                          % Set counter to zero
            o_extract = 0;
            for q = 1:3                         % For all three regions
                A_o_q = Aol(:,:,q);             % Overlapping surface per region
                o_extract = A_o_q(rel_WT(i-length(Up)),Dwn(i-length(Up)));% Extract overlapping surface per region
                o_sum = o_sum + o_extract;            % Sum the extractions
            end
                                     
                Dw_q1 = Dw(:,:,1);          %Wake diameter matrix region 1             
                Dw_q2 = Dw(:,:,2);          %Wake diameter matrix region 2   
                Dw_q3 = Dw(:,:,3);          %Wake diameter matrix region 3   
                D2_extract1 = Dw_q1(rel_WT(i-length(Up)),Dwn(i-length(Up)));    %Wake diameter of region 1 - of most important upwind turbine
                D2_extract2 = Dw_q2(rel_WT(i-length(Up)),Dwn(i-length(Up)));    %Wake diameter of region 1 - of most important upwind turbine
                D2_extract3 = Dw_q3(rel_WT(i-length(Up)),Dwn(i-length(Up)));    %Wake diameter of region 1 - of most important upwind turbine
                D2_extract_vec = [D2_extract1 D2_extract2 D2_extract3]; %Diameters for research purpose           
            % Necessary values for finding the DEL
            A_rotor = pi*(D/2)^2;               % Surface of the rotor
            D2_l(i) = D2_extract3;              % Surface of the wake diameter - of most important upwind turbine
            WS_l(i) = (U(1)-Ut(Dwn(i-length(Up)),1))/U(1);      % WindSpeed deficit  
            O_l(i)  = o_sum/A_rotor;            % Fraction of overlap
            D2_extract_total(i-length(Up),[1:3]) = D2_extract_vec;   %Diameters for research purpose
            % Find corresponding DEL
            run FindDEL_downwind
        end
    end
    
    DEL_tot = 0;                                % Initialize DEL_tot
    DEL_tot = DEL_tot + DEL(i);                 % Sum DELs
end
        