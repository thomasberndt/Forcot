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
    princeton = LoadPrincetonForc();

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

    subplot(3,4,1);
    PlotFORC(princeton.unsmoothed);
        
    M = princeton.grid.M;
    
    as = logspace(-5, -3, 5);
    p  = NaN(size(as));
    np = NaN(size(as));
    
    for n = 1:length(as)
        subplot(3,4,1+n);
        SF = as(n);
        [~, rho3, f3] = SmoothForcFft(M, Ha, Hb, SF);
        
        forc = princeton.unsmoothed; 
        forc.maxHu = forc.maxHu*0.9;
        forc.rho = rho3(1:end-1,1:end-1); 
        [~, h, ax] = PlotFORC(forc);
        
        title(num2str(log10(SF)));
        drawnow
        
        
        subplot(3,4,7+n);
        
        res = forc; 
        res.rho = princeton.unsmoothed.rho - rho3(1:end-1,1:end-1); 
        [~, h, ax] = PlotFORC(res);
        
        title(['Res ' num2str(log10(SF))]);
        drawnow
    end


