function iBin = get_user_distribution_bin( distribVars, distribValues )
% This function gets the 1-D index into the user-supplied distribution table given a value for each of the table's variables (distribValues).
%
% Syntax is:  iBin = get_user_distribution_bin( distribVars, distribValues )
%
% where:
%      iBin            - Filename of the user-supplied joint PDF file
%      distribVars     - structure array containing the fields BinMin, BinWidth, VarnName, NumBins.  
%      distribValues   - The specific values of each variable in the joint distribution for the current time-series
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

   nVars = length(distribVars);
   
      % Get the individual bin numbers for each variable
      for i = 1:nVars %GMS 2/20/13
        bins(i) = ceil( (distribValues(i)-distribVars(i).BinMin) ./ distribVars(i).BinWidth ); %GMS 2/20/13
        nBins(i) = distribVars(i).NumBins; %GMS 2/20/13
      end %GMS 2/20/13
      
   

      % Use the sub2ind() function to obtain the linear index.
   switch nVars
       case 1
           iBin = bins(1);
       case 2
           iBin = sub2ind( nBins, bins(1), bins(2) );
       case 3
           iBin = sub2ind( nBins, bins(1), bins(2), bins(3) );
       case 4
           iBin = sub2ind( nBins, bins(1), bins(2), bins(3), bins(4) );
       case 5
           iBin = sub2ind( nBins, bins(1), bins(2), bins(3), bins(4), bins(5) );
       case 6
           iBin = sub2ind( nBins, bins(1), bins(2), bins(3), bins(4), bins(5), bins(6) );
       case 7
           iBin = sub2ind( nBins, bins(1), bins(2), bins(3), bins(4), bins(5), bins(6), bins(7) );
       otherwise
           beep
           error( '    the user-supplied distribution must have less than 8 variables!' );
   end

end
