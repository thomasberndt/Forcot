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
    maxHc = princeton.unsmoothed.maxHc;
    maxHu = princeton.unsmoothed.maxHu;
        
    M = princeton.grid.M;
    [~, rho_unsmoothed, f_unsmoothed] = SmoothForcFft(M, Ha, Hb, 0);
    
    unsmoothed2 = princeton.unsmoothed;
    unsmoothed2.rho = rho_unsmoothed(1:end-1,1:end-1);
    
    idx = GetVisibleForcPart(rho_unsmoothed, ...
        princeton.grid.Hc, princeton.grid.Hu, maxHc, maxHu, 0.005);
    %%
    SFs = logspace(-8, -2, 51);
    crosscor = NaN(size(SFs));
    CC = NaN(size(SFs));
    DD = NaN(size(SFs));
    
    for n = 1:length(SFs)
        SF = SFs(n);
        [~, rho3, f3] = SmoothForcFft(M, Ha, Hb, SF);
        rho4 = rho3;
        rho4(~idx) = NaN; 
        
        res = rho_unsmoothed - rho4;        
        
        A = nanstd(rho4(:));
        B = nanstd(res(:));
        C = nancov(rho4(1:end-1), rho4(2:end));
        D = nancov(res(1:end-1), res(2:end)); 
        crosscor(n) = C(1,2)/D(1,2);
        CC(n) = C(1,2);
        DD(n) = D(1,2); 
    end
    
    clf
    findpeaks(CC.^2, log10(SFs));
    hold on
    findpeaks(DD.^2, log10(SFs));
    findpeaks(log10(CC.^2./DD.^2), log10(SFs));
    grid on
    [~, p] = findpeaks(-DD); 
    if ~isempty(p)
        disp(log10(SFs(p))); 
        SF = SFs(p(1));
    end
    SF = 10.^(-input('SF: '));
%     end
        
    [~, rho3, f3] = SmoothForcFft(M, Ha, Hb, SF);
        
    forc = princeton.unsmoothed; 
    forc.maxHu = forc.maxHu*0.9;
    forc.rho = rho3(1:end-1,1:end-1); 
    [~, h, ax] = PlotFORC(forc);
        
    title([princeton.filename '(SF=' num2str(log10(SF)) ')']);
    

