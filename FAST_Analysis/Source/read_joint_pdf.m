function [distribVars, distribTable, distribName] = read_joint_pdf( distribFilename )
% This function reads  a user-supplied distribution table and its associated information.
%
% Syntax is:  [distribVars, distribTable] = read_joint_pdf( distribFilename )
%
% where:
%      distribFilename      - Filename of the user-supplied joint PDF file
%      distribVars          - structure array containing the fields BinMin, VarnName, BinWidth, NumBins.  
%      distribTable         - The multi-variate joint distribution table
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
   
   flun         = fopen(distribFilename,'r','l');
   if ( flun < 0 )
      beep
      error( '    Could not open "%s" for reading.', distribFilename );
   end

   fprintf( '    Reading "%s".\n', distribFilename);
   
   precision    = fread(flun,1,'int16');
   distribName  = fread(flun,256,'char');
   nDistribVars = fread(flun, 1, 'int16');
   
   distribVars  = repmat( struct( 'NumBins',0, 'BinMin',0,'BinWidth',0 ), 1, nDistribVars );
   nBins        = zeros(1,nDistribVars);
   
      % Read information about each binned variable
   for iVar = 1:nDistribVars
      distribVars(iVar).VarName  = fread(flun, 256,'char');
      nBins(iVar)                = fread(flun, 1, 'int16');
      distribVars(iVar).NumBins  = nBins(iVar);
      distribVars(iVar).BinMin   = fread(flun, 1, 'real*4');
      distribVars(iVar).BinWidth = fread(flun, 1, 'real*4');
   end
   
   format = sprintf('real*%d',precision);
   distribTable = fread(flun, prod(nBins), format);
   
   if ( nDistribVars > 1 )
      distribTable = reshape(distribTable,nBins);
   end
   
   fclose(flun);
   
end