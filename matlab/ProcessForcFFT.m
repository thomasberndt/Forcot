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

    subplot(3,2,1);
    PlotFORC(princeton.unsmoothed);
        
    M = princeton.grid.M;
    sz = size(M);
    
    f = ForcFft(M);
    
    as = logspace(-5, -3, 5);
    p  = NaN(size(as));
    np = NaN(size(as));
    
    for n = 1:length(as)
        subplot(3,2,1+n);
        SF = as(n);
        [~, rho3, f3] = SmoothForcFft(f, SF, sz);
        
        forc = princeton.unsmoothed; 
        forc.maxHu = forc.maxHu*0.9;
        forc.rho = rho3(1:end-1,1:end-1); 
        [~, h, ax] = PlotFORC(forc);
        params = struct;
        params.SF = SF; 
        params.f = f; 
        params.sz = sz; 
        params.forc = forc;
        if n == 1
            params.minSF = as(1)/(as(2)/as(1)); 
        else
            params.minSF = as(n-1);
        end
        if n == length(as)
            params.maxSF = as(end)*(as(end)/as(end-1)); 
        else
            params.maxSF = as(n+1);
        end
        
        h(1).ButtonDownFcn = {@Callback, params}; 
        title(num2str(log10(SF)));
    end


    function Callback(ObjectH, EventData, params)
    
        if params.minSF < 0.5 * params.maxSF
    
            as = logspace(log10(params.minSF), log10(params.maxSF), 5); 
            for n = 1:length(as)
                subplot(3,2,1+n);
                SF = as(n);
                [~, rho3] = SmoothForcFft(params.f, SF, params.sz);
                forc = params.forc;
                forc.rho = rho3(1:end-1,1:end-1);

                [~, h, ax] = PlotFORC(forc);

                params2 = struct;
                params2.SF = SF; 
                params2.f = params.f; 
                params2.sz = params.sz; 
                params2.forc = forc;
                if n == 1
                    params2.minSF = as(1)/(as(2)/as(1)); 
                else
                    params2.minSF = as(n-1);
                end
                if n == length(as)
                    params2.maxSF = as(end)*(as(end)/as(end-1)); 
                else
                    params2.maxSF = as(n+1);
                end

                h(1).ButtonDownFcn = {@Callback, params2}; 
                title(num2str(log10(SF)));
            end
            
        else
    

            [~, rho3, f3] = SmoothForcFft(params.f, params.SF, params.sz);
            forc = params.forc;
            forc.rho = rho3(1:end-1,1:end-1);

            clf
            PlotFORC(forc);
        end
    end

