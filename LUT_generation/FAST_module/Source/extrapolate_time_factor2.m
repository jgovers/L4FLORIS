function timeFactor = extrapolate_time_factor2(iDLC, V, Vin, Vout, distribVars, designLife, timeSpentInBinsPP, timeSpentInBinsIdle, availability, distribValues, distribTable)
% This function computes the time scaling factor for lifetime fatigue calculations based on a user-supplied distribution.
%
% Syntax is:  timeFactor = extrapolate_time_factor2(iDLC, V, Vin, Vout, distribVars, designLife, timeSpentInBinsPP, timeSpentInBinsIdle, availability, distribValues, distribTable)
%
% where:
%      iDLC                 - Design load case type.  1 = normal operation, 2 = idling, 3 = discrete events
%      V                    - Mean wind speed of the data
%      Vin                  - The turbine's Cut-in wind speed
%      Vout                 - The turbine's Cut-out wind speed
%      distribVars          - structure array containing information about the user-supplied distribution
%      designLife           - Design lifetime in seconds
%      timeSpentInBinsPP    - The total elapsed time of all power production DLC input data files falling in the bin containing V (seconds)
%      timeSpentInBinsIdle  - The total elapsed time of all idling DLC input data files falling in the bin containing V (seconds)
%      availability         - The availability factor for the turbine.  1 = always available
%      distribValues        - The specific values of each variable in the joint distribution for the current time-series
%      distribTable         - The multi-variate joint distribution table
%
% 
% If this is a discrete event DLC (3) then the time factor is simply 1, and no time scaling is performed.
%
% If we are between Vin and Vout, then we need to take into account availability.  
% If this is a normal operation DLC (1), then multiple the time factor by availability.
% If this is an idling DLC (2), then multiply by (1-availability).
%
% If we are outside [ Vin, Vout ], and the DLC type is  2, then simply scale using
% the design lifetime and the weibull distribution.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   
   if ( iDLC == 3 )
      timeFactor = 1.0;
      return
   end
   
   
       % Determine the 1-D bin number in the user-supplied distribution
       % table given the values of all distribution variables.
       iBin = get_user_distribution_bin(distribVars, distribValues);
       probabilityFactor = distribTable(iBin);
   
   if ( ( V <= Vout ) || (V > Vin) ) 
   % if ( (iBin <= ( nBins(1)+nBins(2) )) && (iBin > nBins(1)) )
      % nBins(1) + 1 = the first bin in the region Vin to Vout
      % nBins(1) + nBins(2) = last bin in the region Vin to Vout
      if ( iDLC == 1)
         % Normal ops DLC
         a = availability;
         timeInBin = timeSpentInBinsPP(iBin);
      else 
         % Idling DLC
         a = 1 - availability;
         timeInBin = timeSpentInBinsIdle(iBin);
      end
   else
      % Idling or normal operation outside of Vin and Vout
      if ( iDLC == 1)
         % Normal ops DLC
         a = 0;   % force the timeFactor to equal zero for normal operation DLC files outside range Vin to Vout!!
         timeInBin = timeSpentInBinsPP(iBin);
      else 
         % Idling DLC
         a = 1;
         timeInBin = timeSpentInBinsIdle(iBin);
      end
       
   end
   
   timeFactor = designLife*probabilityFactor*a / timeInBin;
   
      
end