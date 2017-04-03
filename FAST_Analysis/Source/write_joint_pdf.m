function status = write_joint_pdf( distribFilename, distribName, precision, distribVars, distribTable )
% This function writes a user-supplied distribution table and its associated information.
%
% Syntax is:  [distribVars, distribTable] = read_joint_pdf( distribFilename )
%
% where:
%      distribFilename      - Filename of the user-supplied joint PDF file
%      distribName          - A 256 character string name of the distribution
%      precision            - 4 or 8, indicating single or double precision floating point values are used to store the table data
%      distribVars          - structure array containing the fields BinMin, VarnName, BinWidth, NumBins.  
%      distribTable         - The multi-variate joint distribution table
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

   if (length(distribName) > 256)
      beep
      error( '    Distribution name must be 256 or less characters long.' );
   end
   
   nDistribVars = length(distribVars);
   
   flun = fopen(distribFilename,'w','l');
   if ( flun < 0 )
      beep
      error( '    Could not open "%s" for writing.', distribFilename );
   end
   
   count = fwrite(flun,precision,'int16');
   fullName = blanks(256);
   fullName(1:length(distribName)) = distribName;
   count = fwrite(flun,fullName,'char');
   count = fwrite(flun, nDistribVars, 'int16');
   
   fullVarName = blanks(256);
   
   for iVar = 1:nDistribVars
      len = length(distribVars(iVar).VarName);
      if ( len > 256 )     
         beep
         error( '    Distribution variable names must be 256 or less characters long.' );
      end
      
      fullVarName(1:len) = distribVars(iVar).VarName;
      count = fwrite(flun, fullVarName, 'char');
      count = fwrite(flun, distribVars(iVar).NumBins, 'int16');
      count = fwrite(flun, distribVars(iVar).BinMin, 'real*4');
      count = fwrite(flun, distribVars(iVar).BinWidth, 'real*4');
      
   end
   format = sprintf('real*%d',precision);
   count = fwrite(flun, distribTable, format);
   fclose(flun);
end