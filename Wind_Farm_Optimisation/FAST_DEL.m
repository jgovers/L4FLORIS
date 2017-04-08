function [DELtot,data] = FAST_DEL(N,Up,Dwn,I,Ic,Dw,Y,yw,Ut,Ueff_matrix,DEL_summary,D, U, Dw3_vector, C2C_vector, Ueff_vector, sim_name)
    %Initialize data matrix
    data = zeros(N,8);
    %Fill column 1 with upwind turbine numbers
    data(1:length(Up),1) = Up;
    %Concatenate column 1 with downwind turbine numbers
    data((length(Up)+1):(length(Up)+length(Dwn)),1) = Dwn;
    %Fill column 2 with corresponding upwind turbine    
    data((length(Up)+1):(length(Up)+length(Dwn)),2) = I;
    %Fill column 3 with corresponding most relevant upwind turbine
    data((length(Up)+1):(length(Up)+length(Dwn)),3) = Ic;
    %Fill column 4 with corresponding wake diameter of region 3
    for i = 1 : length(Dwn)
    data((length(Up)+i):(length(Up)+length(Dwn)),4) = Dw(Ic(i),Dwn(i),3);
    end
    % Fill column 5 with corresponding C2C distance
    for i = 1 : length(Dwn)
    data((length(Up)+i):(length(Up)+length(Dwn)),5) = ...
        (Y(Ic(i))-Y(Dwn(i)))+(yw(Ic(i),Dwn(i))-Y(Ic(i)));
    end
    %Fill column 6 with corrsponding effective wind speed
    data(:,6) = round(Ut,4);
    
    DELtot = 0;
    for i = 1:N
           Dw3 = data(i,4);
           C2C = data(i,5);
           Ueff = data(i,6);
           [DEL,filenumber] = LookupDEL(Dw3,C2C,Ueff,Ueff_matrix,DEL_summary,N,D,U,Dw3_vector,C2C_vector,Ueff_vector,sim_name);
           % Corresponding DEL
           data(i,7) = round(DEL);
           % Corresponding filenumber
           data(i,8) = filenumber;
           DELtot = DELtot + DEL;
    end
    % Generate a readable date matrix for investigation purposes
    data = vpa(data);
end