% function processed = ProcessForcFFT(princeton)
% Takes raw princeton VRM FORC and applies, drift correction and smoothing.
% princeton - Optional. A princeton FORC struct. If this argument is
% not given, a dialog is shown for the user to open a file. 
%
% As smoothing is quite slow, temporary files are created such that
% smoothing only has to be done once for each file with any given smoothing
% settings. 
%
% OUTPUT: 
% processed - a princeton forc struct with an additional field:
% processed.smooth - containes the smoothed FORC (struct). 
    
%     if nargin < 1

    
    while n < length(files)
        filename = sprintf('%s/%s', pathname, files{n}); 
        princeton = LoadPrincetonForc(filename);

        princeton.correctedM = DriftCorrection(...
                princeton.measurements.M, princeton.measurements.t, ...
                princeton.calibration.M, princeton.calibration.t);

        princeton.grid = RegularizeForcGrid(princeton.correctedM, ...
            princeton.measurements.Ha, princeton.measurements.Hb); 

        princeton.unsmoothed = CalculateForc(princeton.grid); 

        rho = princeton.unsmoothed.rho; 
        Ha = princeton.unsmoothed.Ha; 
        Hb = princeton.unsmoothed.Hb; 
        Hc = princeton.unsmoothed.Hc; 
        Hu = princeton.unsmoothed.Hu; 
        maxHc = princeton.unsmoothed.maxHc;
        maxHu = princeton.unsmoothed.maxHu;

        M = princeton.grid.M;   


%         figure
        subplot(1,2,1);
        tic
        [~, rho3, SF] = SmoothForcFft(M, Ha, Hb);

        subplot(1,2,2);
        forc = princeton.unsmoothed; 
        forc.maxHu = forc.maxHu*0.9;
        forc.rho = rho3(1:end-1,1:end-1); 
        [~, h, ax] = PlotFORC(forc);

        title([princeton.filename '(SF=' num2str(SF) ')']);
        
        input('next?');
        n = n + 1;
    end
