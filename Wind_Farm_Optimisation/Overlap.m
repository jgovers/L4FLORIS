function [ Aol ] = Overlap( Yw,Dw,X,Y,i,j,q,D )
% Surface overlap per turbine
%-------------------------------------------------------------------------%
% Variables:
% Wake positions (Yw),
% Wake zone diameter (Dw),
% Turbine diameter(Dt), 
% Turbine Coordinates downstream(X) crosstream(Y), 
% Upstream turbine index(i) downstream turbine index(j), 
% Wake region index 1,2 or 3 (q)
%-------------------------------------------------------------------------%

% Wake centerline offset distance.
d = abs(Y(j)-Yw(i,j));
% Wake radius of region q per turbine j
Rw = Dw(i,j,q)/2;
% Rotor radius
Rt = D/2;

% No regional wake overlap
if d >= (Rw+Rt)
    Aol = 0; 
% Full regional wake overlap 
elseif d <= abs(Rw-Rt)
    if Rt > Rw
    Aol = pi*Rw^2;
    else
    Aol = pi*Rt^2; 
    end
% Partial regional wake overlap    
elseif d > abs(Rw-Rt) && d < (Rw+Rt)
    
    %Calculation of partial overlapping circle surfaces
    d1   = (d^2-(D/2)^2+(Dw(i,j,q)/2)^2)/(2*d);
    d2   = (d^2+(D/2)^2-(Dw(i,j,q)/2)^2)/(2*d);
    phiw = acos(d1/(Dw(i,j,q)/2))*2;
    phit = acos(d2/(D/2))*2;
    
    % Surface overlap wake region
    Aolw = phiw*(((Dw(i,j,q)/2)^2)/2)-sqrt((Dw(i,j,q)/2)^2-d1^2)*d1;
    % Surface overlap turbine
    Aolt = phit*(((D/2)^2)/2)-sqrt((D/2)^2-d2^2)*d2;
    % Surface overlap total
    Aol  = Aolw+Aolt;
end
end

