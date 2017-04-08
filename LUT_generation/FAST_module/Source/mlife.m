function [ Fatigue, Statistics, FileInfo ] = mlife(settingsFile, dataDirectory, outputDirectory, Statistics, FileInfo, Fatigue, inputData)
   % The mlife function calculates statistics and fatigue related information
   % using an NREL CAE tool-style settings file as input.  Data files are
   % loaded into memory one at a time, minimizing the memory requirements.
   % Fatigue calculations are performed in accordance to IEC 61400-1,
   % edition 3.
   %
   % Syntax is:  [ Fatigue, Statistics, FileInfo ] = mlife(settingsFile, dataDirectory, outputDirectory, Statistics, FileInfo, Fatigue, inputData);
   %
   % where:
   %      settingsFile    - Filename of the input settings file
   %      dataDirectory   - (optional) This is the location for all data files when a 
   %                          relative path is used in the 'Input Files' section of the
   %                          settings file.  When absent, the settings file folder is used as the data
   %                          directory.  
   %      outputDirectory - (optional) This is the location for all output files generated by MCrunch.
   %                          When absent, the settings file folder is used.
   %      Statistics      - (optional) An instance of the Statistics structure.  When this
   %                          parameter is present, the program does not parse a settings file.
   %      FileInfo        - (optional) An instance of the FileInfo structure.
   %      Fatigue         - (optional) An instance of the Fatigue structure.
   %      inputData       - (optional) A matrix of input data.  When this parameter is
   %                          present, no data files are read.
   %     
   %
   %      The optional input structures are:
   %
   %       Statistics.DoStats      - (boolean) compute statistics for each file and
   %                                 aggregate statistics for all files
   %                 .SumStatChans - integer array of 1 by nSummaryChannels containing a list of channel indices
   %                                 for which to report summary statistics to a text file                                   
   %                 .WrStatsTxt   - (boolean) write out statistics results to a text file
   %                 .WrStatsXLS   - (boolean) write out statistics results to an excel file
   %
   %    
   %      FileInfo.RootName      -  (string) text which prepends the filenames which depend on multiple input files.
   %              .TitleLine     -  location of title line in the input data file             
   %              .NamesLine     -  location of channel names line in the input data file
   %              .UnitsLine     -  location of channel units line in the input data file
   %              .FirstDataLine -  location of start of channel data in the input data file
   %              .nChannels     - (integer) number of data channels
   %              .nFiles        - (integer) number of data files
   %              .nSamples      -  1 x nFiles array.  Total datapoints in each input file.
   %              .TimeChan      - (integer) index of the time channel
   %              .WSChan        - (integer) index of the windspeed channel
   %              .Title         - (cell array) nFiles x 1 title description for the current data file
   %              .UserNames     - (boolean) true if names and/or units are provided in settings file or input parameter, false if
   %                                   they are to be read from a time series input file
   %              .Names         - (cell array) 1 x nChannels names of each channel
   %              .Units         - (cell array) 1 x nChannels unit descriptor of each channel
   %              .FileName      - (cell array) nFiles x 1 filenames of input data files
   %              .FileFormat    - Format of input files.  1 = ascii format, 2 = binary
   %              .RealFmt       - (string) format for real valued data.  Example: '%12.4f'; 
   %              .PSFtype       - (integer array) 1 x nChannels index into the DLCs(i).PSF array, if = 0 then tells MLife not to apply a PSF to this channel
   %              .DLC_Occurrences - (integer array) 1 x DLCs(3).NumFiles array designating the number of times each DLC file occurs over the design lifetime.
   %              .DLCs          - A structure array containing information about the DLCs
   %                               DLCs(i).NumFiles - (integer) number of files associated with this DLC
   %                               DLCs(i).PSF      - (float array) 1 x 4 array of partial safety factor values
   %                               DLCs(i).DLC_Name - (string) name of this DLC
   %              .nLoadRoses    - (integer) number of load rose tables
   %              .LoadRoses     - Structure array containing information about load rose tables.
   %                               LoadRoses(i).Name     - (string) name of the load rose
   %                               LoadRoses(i).Channel1 - (integer) index of 0 degrees channel
   %                               LoadRoses(i).Channel2 - (integer) index of 90 degrees channel
   %                               LoadRoses(i).nSectors - (integer) number of generated channels
   %              .CalcChan      - A structure array containing information for generating calculated
   %                               channels.  It must have the following format (all are strings):
   %                               CalcChan(i).Name  - The calculated channel's name.
   %                               CalcChan(i).Units - The calculated channel's units.
   %                               CalcChan(i).Eqn   - The calculated channel's equation.
   %
   %       Fatigue.nFatigueChannels    - (integer) number of channels on which to perform fatigue-related calculations
   %              .FiltRatio           - (single)  fraction of the maximum range of each channel will be 
   %                                       the filtered out of peak finding results array
   %              .DesignLife          - (integer) number of seconds in the design lifetime
   %              .BinCycles           - (boolean) bin the cycle ranges
   %              .UCMult              - (single)  weight of unclosed cycles [0,1]
   %              .DoShortTerm         - (boolean) calculate short-term DELs and damage rates for each input file.
   %              .DoLife              - (boolean) perform lifetime calculations
   %              .weibullShapeFactor  - (single)  shape factor of the weibull distribution.  If =2 then you need to set .weibullMeanWS else set .weibullScaleFactor
   %              .weibullMeanWS       - (single)  the mean wind speed of the distribution.  User-supplied if weibullShapeFactor = 2
   %              .weibullScaleFactor  - (single)  scale factor of the weibull distribution.  User-supplied if weibullShapeFactor ~= 2
   %              .WSin                - (single)  cut-in windspeed of the turbine
   %              .WSout               - (single)  cut-out windspeed of the turbine
   %              .WSmax               - (single)  maximum wind speed of the highest wind speed bin
   %              .WSMaxBinSize        - (single)  maximum width of the wind speed bins
   %              .WrShortTermTxt      - (boolean) write short-term results to text files 
   %              .WrShortTermXLS      - (boolean) write short-term results to excel file 
   %              .WrLifeTxt           - (boolean) write lifetime results to text files 
   %              .WrLifeXLS           - (boolean) write lifetime results to excel files 
   %              .EquivalentFrequency - (single) Freqency of the damage equivalent cycles
   %              .useWeibull          - (boolean) use the windspeed distribution in fatigue calculations (For testing purposes only)
   %              .ChanInfo            - A structure array containing information for generating calculated
   %                                      channels.  It must have the following format (all are strings):
   %                                      ChanInfo(i).Chan - (integer) index of this fatigue channel in the main channel list.
   %                                      ChanInfo(i).NSlopes - (integer) number of Wohler exponents to use for this channel.
   %                                      ChanInfo(i).SNSlopes - (single array) list of Wohler exponents
   %                                      ChanInfo(i).BinFlag - (string) Determine if bin width, 'BW', or bin number, 'BN' is being specified by the user.
   %                                      ChanInfo(i).BinVal - (single) number of bins to use (if 'BN' was specified in BinFlag field ) or
   %                                                            width of bin to use (if 'BW' was specified in the BinFlag field)
   %                                      ChanInfo(i).TypeLMF - (string) 'AM' = use aggregate mean to set the fixed mean for this channel,
   %                                                                     'WM' = use a Weibull distribution weighted mean to determin the fixed mean
   %                                                                     'value' = use the value in the field LMF instead of calculating a fixed mean                                                        
   %                                      ChanInfo(i).LMF - (single) fixed mean value to use if TypeLMF was set to 'value'
   %                                      ChanInfo(i).LUlt - (single) ultimate load
   %              .DEL_AsRange         - (boolean) output DEL values as ranges or amplitudes
   %    					.DEL_Type						 - (integer) type of DEL results to calculate: 1 = fixed-mean load, 2 = zero fixed-mean load, 3 = both
   %							.GoodmanFlag				 - (integer) 0 = do not use the Goodman correction, 1 = use Goodman, 2 = compute with and without correction
   %              .nGroups             - (integer) number of DEL groups for the results tables
   %              .Groups              - 1 x nGroups structure array defining each fatigue group
   %                                         Groups(i).name           - (string) name of the fatigue group
   %                                         Groups(i).channelIndices - (integer array) list of fatigue channels for a given group [0,nFatigueChannels]
   %
   %
   %
   %     The results structures return the following fields
   %
   %       Statistics.Minima        - (single) nFiles x nChannels array of minimum channel values.
   %       Statistics.MinInds       - (integer) nFiles x nChannels array of index locations of minimum channel values.
   %       Statistics.Maxima        - (single) nFiles x nChannels array of maximum channel values.
   %       Statistics.MaxInds       - (integer) nFiles x nChannels array of index locations of maximum channel values.
   %       Statistics.Range         - (single) nFiles x nChannels array of the maximum range (max-min).
   %       Statistics.Means         - (single) nFiles x nChannels array of channel means.
   %       Statistics.StdDevs       - (single) nFiles x nChannels array of channel standard deviations.
   %       Statistics.Skews         - (single) nFiles x nChannels array of channel skewness.
   %       Statistics.Kurtosis      - (single) nFiles x nChannels array of channel kurtosis.
   %       Statistics.AggMinima     - (single) nChannels array of the aggregate minimums across all files.
   %       Statistics.AggMinInds    - (single) nChannels array of indices of aggregate minimums.
   %       Statistics.AggMaxima     - (single) nChannels array of the aggregate maximums across all files.
   %       Statistics.AggMaxInds    - (single) nChannels array of indices of aggregate maximums.
   %       Statistics.AggMaxFileNum - (single) nChannels array of the index of input file where the aggregate maximum occurs.
   %       Statistics.AggMinFileNum - (single) nChannels array of the index of input file where the aggregate minimum occurs.
   %       Statistics.AggRange      - (single) nChannels array of the aggregate maximum range across all files.
   %       Statistics.AggMeans      - (single) nChannels array of the aggregate means across all files.
   %       Statistics.AggStdDevs    - (single) nChannels array of the aggregate standard deviation across all files.
   %       Statistics.AggSkews      - (single) nChannels array of the aggregate skewness across all files.
   %       Statistics.AggKurtosis   - (single) nChannels array of the aggregate kurtosis across all files.
	% 
   %       Fatigue.lifetimeEquivalentCycles - (single) number of equivalent cycles durning design lifetime
   %              .RFPerStr                 - (string) lifetime period expressed as a string
   %              .NumPeaks                 - (double) nFiles x nChannels array of the number of peaks found in the time series data
   %              .Peaks                    - (cell array) nFiles x nChannels array of all peaks found in the time series data
   %              .File                     - 1 x nFiles structure array of file-related fatigue results
   %              .File(i).Channel          - 1 x nFatigueChannels channel results for a given file
   %              .File(i).Channel(j).DEL_FixedMeans - (double) 1 x NSlopes array of short-term DEL about a fixed mean.  One result for each Wohler exponent
   %              .File(i).Channel(j).DEL_ZeroMeans  - (double) 1 x NSlopes array of short-term DEL about a fixed mean of zero.  One result for each Wohler exponent
   %              .File(i).Channel(j).DEL_NoGoodman  - (double) 1 x NSlopes array of short-term DEL about a fixed mean of zero, 
   %                                                               without applying the Goodman correction to the load ranges.  One result for each Wohler exponent
   %              .File(i).Channel(j).DamageRate     - (double) 1 x NSlopes array of damage-rates per file.  One result for each Wohler exponent
   %              .File(i).Channel(j).DamageRate_NoGoodman     - (double) 1 x NSlopes array of damage-rates without the Goodman correction.  One result for each Wohler exponent
   %              .File(i).Channel(j).binnedCycleCounts_FixedMeans     - (integer) 1 x nBins array of the cycle counts for the binned fixed-mean corrected load ranges.
   %              .File(i).Channel(j).binnedCycleCounts_ZeroMeans     - (integer) 1 x nBins array of the cycle counts for the binned zero fixed-mean corrected load ranges.
   %              .File(i).Channel(j).binnedCycleCounts_NoGoodman     - (integer) 1 x nBins array of the cycle counts for the binned un-corrected load ranges.
   %              .Channel                  - 1 x nFatigueChannels array of structures containing  lifetime fatigue results for each channel 
   %              .Channel(i).lifetimeDEL_FixedMeans - (double) 1 x NSlopes array of lifetime DEL about a fixed mean.  One result for each Wohler exponent
   %              .Channel(i).lifetimeDEL_ZeroMeans  - (double) 1 x NSlopes array of lifetime DEL about a fixed mean of zero.  One result for each Wohler exponent
   %              .Channel(i).lifetimeDEL_NoGoodman  - (double) 1 x NSlopes array of lifetime DEL about a fixed mean of zero without the Goodman correction.  One result for each Wohler exponent
   %              .Channel(i).lifetimeDamage        - (double) 1 x NSlopes array of lifetime damage over the design lifetime.  One result for each Wohler exponent
   %              .Channel(i).timeUntilFailure      - (double) 1 x NSlopes array of time in seconds until failure.  One result for each Wohler exponent
   %              .Channel(i).lifetimeDamage_NoGoodman        - (double) 1 x NSlopes array of lifetime damage over the design lifetime for cycles without using the Goodman correction.  One result for each Wohler exponent
   %              .Channel(i).timeUntilFailure_NoGoodman      - (double) 1 x NSlopes array of time in seconds until failure for cycles without using the Goodman correction.  One result for each Wohler exponent
   %              
   %
   % Example:
   %     [FatigueOut, StatisticsOut] = mlife( 'MySettings.mlif', 'Y:\MyFolder\DataFolder\', 'Z:\MyFolder\OutputFolder\' );
   %     mlife( [], [], 'Z:\MyFolder\OutputFolder\', Statistics, FileInfo, Fatigue, inputData );
   %
   % Calls To:
   %     
   %    compute_aggregate_statistics.m
   %    compute_brief_aggregate_statistics.m
   %    compute_brief_statistics.m
   %    compute_channel_fixed_means.m
   %    compute_fatigue.m
   %    compute_statistics.m
   %    compute_windspeed_bins.m
   %    determine_peaks.m
   %    process_mlife_inputs.m
   %    race_track_filter.m
   %    read_one_file.m
   %    read_settings.m
   %    validate_path.m
   %    write_aggregate_statistics_as_text.m
   %    write_compact_lifetime_results_as_excel.m
   %    write_lifetime_damage_as_text.m
   %    write_lifetime_dels_as_text.m
   %    write_shortterm_damage_rate_as_text.m
   %    write_shortterm_dels_as_text.m
   %    write_shortterm_results_as_excel.m
   %    write_statistics_as_excel.m
   %    write_statistics_as_text.m
   %    write_summary_statistics_as_excel.m
   %    write_summary_statistics_as_text.m
   %    ~\MATLAB\R2011b\toolbox\matlab\iofun\fileparts.m
   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %tic;
   
   
   progName = 'MLife (v1.01.00a-gjh, 30-Oct-2015)';

   fprintf( '\n  Running %s\n\n', progName );
     

      % need to verify the settingsFile is valid
      
   if ( nargin < 4 )
      
      [settingsPathStr, ~, ~] = fileparts(settingsFile);
      settingsPathStr         = validate_path(settingsPathStr);
      
      if (exist(settingsFile, 'file') ~= 2 )
         
         beep;
         error('\nSettings file, %s, does not exist at the path: %s\n',settingsFile, settingsPathStr);
         
      end
      
   end
   
   
      % Processes the different calling options for mlife()
      
   if ( nargin == 1 ) 
      
      [ Statistics, FileInfo, Fatigue ] = read_settings( settingsFile );
      % set dataDirectory and outputDirectory to the location of settingsFile
      [pathstr, ~, ~] = fileparts(settingsFile);
      pathstr         = validate_path(pathstr);
      outputDirectory = pathstr;
      dataDirectory   = pathstr;
      
   elseif ( nargin == 2 )
      
      % make sure directory path ends with appropriate separator
      dataDirectory = validate_path(dataDirectory);
      [ Statistics, FileInfo, Fatigue ] = read_settings( settingsFile, dataDirectory );
      % set outputDirectory to the location of settingsFile
      outputDirectory = settingsPathStr;
      
   elseif ( nargin == 3 )
      
      % make sure directory path ends with appropriate separator
      dataDirectory   = validate_path(dataDirectory);
      outputDirectory = validate_path(outputDirectory);
      [ Statistics, FileInfo, Fatigue ] = read_settings( settingsFile, dataDirectory );
      
   elseif ( nargin == 6 )
      
      dataDirectory        = validate_path(dataDirectory);
      outputDirectory      = validate_path(outputDirectory);
      FileInfo.doScaleData = false;
      FileInfo.Scales      = 0;
      FileInfo.Offsets     = 0;
      
   elseif ( nargin == 7 )
      
      dataDirectory        = [];
      outputDirectory      = validate_path(outputDirectory);
      FileInfo.doScaleData = false;
      FileInfo.Scales      = 0;
      FileInfo.Offsets     = 0;
      
   else
      
      beep;
      error( '\nIncorrect usage of mlife parameter list.\n' );
      
   end
   
   
      % Process the raw inputs regardless of whether that came from an input
      % parameter or a settings file.
   
   [FileInfo, Statistics, Fatigue] = process_mlife_inputs(FileInfo, Statistics, Fatigue, dataDirectory);

   
      % Preallocate and initialize some of the data structures.
       
   nFiles                  = FileInfo.nFiles;
   nChans                  = size( FileInfo.Names, 2 );  
   nFatigueChannels        = Fatigue.nFatigueChannels;
   Fatigue.Peaks           = cell ( nFiles,nFatigueChannels );



   if ( Statistics.DoStats || ~isempty(Statistics.SumStatChans) || Fatigue.DoAggregate)
      
      Statistics.MinInds      = zeros( nFiles, nChans, 'uint32' );
      Statistics.MaxInds      = zeros( nFiles, nChans, 'uint32' );
      Statistics.TotalSamples = 0;
      Statistics.Sums         = zeros( 1, nChans,'double' );
      Statistics.SumsSquared  = zeros( 1, nChans,'double' );
      Statistics.SumsCubed    = zeros( 1, nChans,'double' );
      Statistics.SumsToFourth = zeros( 1, nChans,'double' );
      
   end
   
   Statistics.Means = zeros( 1, nChans, 'single' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  TESTING BLOCK FOR RESTORING PREVIOUS PEAKS DATA BUT READING THE REST FROM THE SETTINGS FILE
%
%%Fatigue.RestorePeaks = true;
%%Fatigue.SavePeaks    = false;
%if (Fatigue.RestorePeaks) 
%   restored = load(Fatigue.RestoreFilename);
%   Fatigue.Peaks     = restored.Peaks;
%   Fatigue.NumPeaks  = restored.NumPeaks;
%   FileInfo.nSamples = restored.nSamples;
%   FileInfo.TotLines = restored.TotLines;
%   Fatigue.ElapTime  = restored.ElapTime;
%   Statistics        = restored.Statistics;
%   FileInfo.FileName = restored.FileNames;
%   FileInfo.nFiles   = restored.totalFiles;
%   FileInfo.nChannels=restored.nChannels;
%   Fatigue.DistribVarValues = restored.DistribVarValues;
%   FileInfo.DLCs     = restored.DLCs;
%   FileInfo.DLC_Occurrences = restored.DLC_Occurrences;
%end
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if (~Fatigue.RestorePeaks) 
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Loop over the input files and perform any necessary file-based processing 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   for iFile=1:nFiles
      
      fprintf( '  Processing file "%s".\n', FileInfo.FileName{iFile} );
      
      if ( iFile <= FileInfo.DLCs(1).NumFiles )
         DLCs = FileInfo.DLCs(1);
      elseif ( iFile <= ( FileInfo.DLCs(1).NumFiles + FileInfo.DLCs(2).NumFiles ) )
         DLCs = FileInfo.DLCs(2);
      else
         DLCs = FileInfo.DLCs(3);
      end
      
      
         %Read one data file into memory for processing
         
      if (nargin < 7)
         
      [ FileInfo.Time, nLines, FileInfo.Title{iFile} ] = read_one_file( ...
            FileInfo.FileName{iFile}, FileInfo.FileFormat, FileInfo.TitleLine, ...
            FileInfo.FirstDataLine, FileInfo.Names, FileInfo.doScaleData, ...
            FileInfo.Scales, FileInfo.Offsets, FileInfo.CalcChan, ...
            FileInfo.LoadRoses, DLCs, FileInfo.PSFtype);
      
      else
         
            % user has passed data directly to mlife()        
         FileInfo.Time = inputData{iFile};
         nLines = length(FileInfo.Time(:,1));
         
      end  % if nargin < 7
      
      FileInfo.nSamples(iFile) = nLines;
      
         % Generate statistics for this single data file, if the user has not
         % selected DoStats, we still must compute the mean and maximum range
         % for each fatigue channel (currently all channel means/ranges are
         % computed in this case
         
      if ( Statistics.DoStats || ~isempty(Statistics.SumStatChans) || Fatigue.DoAggregate)
         
         fprintf('    Generating statistics for "%s".\n', FileInfo.FileName{iFile});
         [ Statistics ] = compute_statistics( iFile, FileInfo.Time, Statistics, nLines, nFiles > 1 );
         
      else
         
         [ Statistics ] = compute_brief_statistics( iFile, FileInfo.Time, Statistics, nLines );
         
      end
      
      
         % Compute elapsed time for the requested channels on a per file basis
         
      beginTime               = FileInfo.Time(      1, FileInfo.TimeChan );
      endTime                 = FileInfo.Time( nLines, FileInfo.TimeChan );
      Fatigue.ElapTime(iFile) = endTime - beginTime;
      
      if ( Fatigue.DoLife || Fatigue.DoShortTerm )
         
            % Build up the Peaks information for the necessary channels
            
         rowRange = 1:nLines; 
         
         for jCh=1:size(Fatigue.ChanInfo, 2)
            
            chan              = Fatigue.ChanInfo(jCh).Chan;
            timeSeriesData    = FileInfo.Time(rowRange,chan);

            [ peaks, nPeaks ] = determine_peaks( timeSeriesData );  

            Fatigue.Peaks{iFile}{jCh}    =  peaks;
            Fatigue.NumPeaks(iFile, jCh) = nPeaks;
            
         end % for jCh
         
      end
      
      fprintf( '\n' );
      
   end % for iFile
   
  
   FileInfo.TotLines = sum(FileInfo.nSamples(:));
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Calculate and Output Statistics
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   if ( Statistics.DoStats || Fatigue.DoAggregate )   
      
      
         % Compute Aggregate Statistics
      
      if (nFiles > 1)
         Statistics = compute_aggregate_statistics( FileInfo.nChannels, FileInfo.nFiles, Statistics );
      end
      
      
         % Generate output files as requested
         
      if ( Statistics.DoStats && Statistics.WrStatsTxt )
         
         for iFile=1:nFiles
            
            [~, name, ~] = fileparts(FileInfo.FileName{iFile});
            outputFile   = [ name '_Statistics.txt' ];                
            outputFile   = [ outputDirectory outputFile ];
            
            write_statistics_as_text( iFile, progName, outputFile, FileInfo, Statistics, FileInfo.RealFmt );
            
         end   % for iFile
         
         outputRoot = [FileInfo.RootName '_Statistics.txt'];       
         outputRoot = [ outputDirectory outputRoot ]; 
                      
         if (nFiles > 1)
            write_aggregate_statistics_as_text( progName, outputRoot, FileInfo, Statistics, FileInfo.RealFmt );
         end
         
      end  % WrStatsTxt
       
      if ( Statistics.DoStats && Statistics.WrStatsXLS )
         
         outputRoot = [FileInfo.RootName  '_Statistics.xlsx'];         
         outputRoot = [ outputDirectory outputRoot ]; 
         
         write_statistics_as_excel( progName, outputRoot, FileInfo, Statistics, FileInfo.RealFmt );
  
      end  % WrStatsXLS
      
   else %if ( Fatigue.FiltRatio > 0 )
      
      
         % Need do compute aggregate ranges for race track filter   
         
      Statistics = compute_brief_aggregate_statistics( FileInfo.nChannels, FileInfo.nFiles, Statistics ); 
      
   end  % if FileInfo.DoStats
   
      
   if ( ~isempty(Statistics.SumStatChans) && Statistics.DoStats)
      
         % Write Summary statistics
         
      for iCh=1:length( Statistics.SumStatChans)
         write_summary_statistics_as_text( outputDirectory, progName, Statistics.SumStatChans(iCh), FileInfo, Statistics, FileInfo.RealFmt );
      end % for
      
      outputRoot = [FileInfo.RootName  '_Summary_Statistics.xlsx'];
      outputRoot = [ outputDirectory outputRoot ]; 
      
      write_summary_statistics_as_excel(progName, outputRoot, FileInfo, Statistics, FileInfo.RealFmt);

   end % SumStatChans
 
%end % if (~restorePeaks)
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Perform Lifetime and/or DEL calculations, and generate output
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   if ( Fatigue.DoLife || Fatigue.DoShortTerm )
      
%if (~Fatigue.RestorePeaks)
         % Filter peaks if requested
         
      if ( Fatigue.FiltRatio > 0 )
         
         fprintf( '  Applying racetrack filter to all files.' );
         
         for iFile=1:nFiles 
            
            for jCh=1:size(Fatigue.ChanInfo, 2)
               
               chan              = Fatigue.ChanInfo(jCh).Chan;
               
               if (nFiles > 1)
                  aggRange = Statistics.AggRange(chan);
               else
                  aggRange = Statistics.Range(chan);
               end
               
               Fatigue.Peaks{iFile}{jCh}    = race_track_filter( Fatigue.Peaks{iFile}{jCh}, Fatigue.FiltRatio*aggRange );
               Fatigue.NumPeaks(iFile, jCh) = length(Fatigue.Peaks{iFile}{jCh});
               
            end % for jCh
            
         end % for iFile

      end % if Fatigue.FiltRatio > 0
%end % if (~restorePeaks)
      
%if (Fatigue.SavePeaks)
%   Peaks             = Fatigue.Peaks;    
%   NumPeaks          = Fatigue.NumPeaks;
%   nSamples          = FileInfo.nSamples;
%   ElapTime          = Fatigue.ElapTime;
%   TotLines          = FileInfo.TotLines;
%   FileNames         = FileInfo.FileName;
%   totalFiles        = FileInfo.nFiles ;
%   nChannels         = FileInfo.nChannels;
%   DistribVarValues  = Fatigue.DistribVarValues;
%   DLCs              = FileInfo.DLCs;
%   DLC_Occurrences   = FileInfo.DLC_Occurrences; 
%   save(Fatigue.SaveFilename, 'Peaks', 'NumPeaks', 'nSamples', 'Statistics', 'ElapTime','TotLines', 'FileNames', 'totalFiles', 'nChannels', 'DistribVarValues', 'DLCs', 'DLC_Occurrences');        
%end

      windChannelMeans = Statistics.Means( :, FileInfo.WSChan );
      
      if (Fatigue.UserDistrib )
         
            % Compute the total time in each wind-speed bin.
            totalNumBins = 1
            for iVar=1:Fatigue.nDistribVars
               totalNumBins = totalNumBins * Fatigue.DistribVars(iVar).NumBins;
            end
         Fatigue.TimePP = zeros( totalNumBins,1 );
         Fatigue.TimeIdle = zeros( totalNumBins,1 );

            % We should only accumulate time for the power production and idling DLC files, not the discrete event files!!
         for iFile=1:FileInfo.DLCs(1).NumFiles
            iBin                    = get_user_distribution_bin(Fatigue.DistribVars, Fatigue.DistribVarValues(:,iFile));
            Fatigue.TimePP(iBin)    = Fatigue.TimePP(iBin) + Fatigue.ElapTime(iFile);
         end
            % Time is accumulated separately for power production and idling
         for iFile=1:FileInfo.DLCs(2).NumFiles
            iBin                   = get_user_distribution_bin(Fatigue.DistribVars, Fatigue.DistribVarValues(:,iFile));
            Fatigue.TimeIdle(iBin) = Fatigue.TimeIdle(iBin) + Fatigue.ElapTime(iFile+nDLC1Files);
         end
         
      else
         
            % Using only the Weibull wind speed distribution.
            % Compute the wind speed bins, their probability, and the time spent in each bin for all the input time-series
         Fatigue = compute_windspeed_bins(Fatigue, windChannelMeans,FileInfo.DLCs(1).NumFiles, FileInfo.DLCs(2).NumFiles );
         
      end
      
      chan             = [ Fatigue.ChanInfo(:).Chan ];
      aggMin           = min( Statistics.Minima( :, chan ) );
      aggMax           = max( Statistics.Maxima( :, chan ) );
      
      range            = aggMax - aggMin;
      
      if (nFiles == 1)
         aggWindChannelMeans = Statistics.Means(1,FileInfo.WSChan);
      else
         aggWindChannelMeans = Statistics.AggMeans(FileInfo.WSChan);
      end
      
      
         % See if all the channels have constant data.  If so, we are done.
         
      if ( max( range ) == 0.0 )
         
         beep;
         fprintf( '\n  All selected fatigue columns have constant data.  Fatigue calculations skipped.\n' );
         
      else
         
         tic; % start clock to show all long the fatigue calculations take
         
            % Determine if we need to compute the fixed mean, if the TypeLMF = 'value', then the LMF has 
            % already been set in the process_mlife_inputs.m function.  Need to pass back the Fatigue structure
            % because the ChanInfo().LMF info is altered within the function.
   
         Fatigue = compute_channel_fixed_means(Fatigue, FileInfo, Statistics.Means, windChannelMeans); 
   
         
            % This is where all the action happens!
            
         Fatigue = compute_fatigue( FileInfo, Fatigue, windChannelMeans );
         
         calcTime = toc;
         
         fprintf( '      Fatigue calculations took %f seconds to complete.\n',calcTime);


            % Write out the results.
         
         if ( Fatigue.WrShortTermTxt && Fatigue.DoShortTerm)
                       
               % Short-term DELs are written to a single text file
            outputRoot = [FileInfo.RootName '_Short-term_DELs.txt'];           
            outputRoot = [ outputDirectory outputRoot ]; 
            write_shortterm_dels_as_text( progName, outputRoot, FileInfo, Fatigue, [windChannelMeans; aggWindChannelMeans] );
            
               % Damage-Rate for each input file is written to a single text file
            outputRoot = [FileInfo.RootName '_Short-term_Damage_Rate.txt'];           
            outputRoot = [ outputDirectory outputRoot ];           
            write_shortterm_damage_rate_as_text( progName, outputRoot, FileInfo, Fatigue, [windChannelMeans; aggWindChannelMeans] );
            
         end     % if  Fatigue.WrShortTermTxt

         if ( Fatigue.WrShortTermXLS && Fatigue.DoShortTerm)
            
               % Short-term results in excel format
               
            outputRoot = FileInfo.RootName;            
            outputRoot = [ outputDirectory outputRoot ]; 
            write_shortterm_results_as_excel( progName, outputRoot, FileInfo, Fatigue, [windChannelMeans; aggWindChannelMeans], FileInfo.RealFmt );
            
         end
         
         if ( Fatigue.WrLifeTxt && Fatigue.DoLife )
            
               % lifetime outputs in text format
               
            outputRoot = FileInfo.RootName ;            
            outputRoot = [ outputDirectory outputRoot ]; 
            
            write_lifetime_dels_as_text( progName, outputRoot, FileInfo, Fatigue );
            write_lifetime_damage_as_text( progName, outputRoot, FileInfo, Fatigue );
            
         end

         if ( Fatigue.WrLifeXLS && Fatigue.DoLife )
            
               % lifetime outputs in excel format
               
            outputRoot = FileInfo.RootName;            
            outputRoot = [ outputDirectory outputRoot ];           
            write_compact_lifetime_results_as_excel( progName, outputRoot, FileInfo, Fatigue, windChannelMeans, FileInfo.RealFmt );
            
         end
         
      end  % if ( max( range ) == 0 )
      
   end    % FileInfo.DoLife
   
   fprintf('\n  MLife processing complete.\n\n');
   
   %toc;
   
end % function mlife (settingsFile)