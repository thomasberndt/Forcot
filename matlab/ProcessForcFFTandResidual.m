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

    %%
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

    figure(1)
    subplot(3,4,1);
    PlotFORC(princeton.unsmoothed);
        
    M = princeton.grid.M;
    [~, rho_unsmoothed, f_unsmoothed] = SmoothForcFft(M, Ha, Hb, 0);
    
    unsmoothed2 = princeton.unsmoothed;
    unsmoothed2.rho = rho_unsmoothed(1:end-1,1:end-1);
    
    subplot(3,4,2);
    PlotFORC(unsmoothed2);
    
    %%
    
    figure(5)
    subplot(1,2,1);
    IM = FourierImage(f_unsmoothed);
    imagesc(IM);
    subplot(1,2,2);
    IM = abs(f_unsmoothed).^2;
    imagesc(log10(fftshift(IM)));
    
    
    %%
    
    idx = GetVisibleForcPart(rho_unsmoothed, ...
        princeton.grid.Hc, princeton.grid.Hu, maxHc, maxHu, 0.005);
    
    as = logspace(-7, -3, 41);
    tp  = NaN(size(as));
    p  = NaN(size(as));
    np = NaN(size(as));
    
    sig = NaN(size(as)); 
    noise = NaN(size(as)); 
    cor = NaN(length(as), 6); 
    crosscor = NaN(size(as));
    
    figure(2)
    clf
    edges = [];
    for n = 1:length(as)
        SF = as(n);
        [~, rho3, f3, tp(n), p(n), np(n)] = SmoothForcFft(M, Ha, Hb, SF);
        rho4 = rho3;
        rho4(~idx) = NaN; 
        sig(n) = nanstd(rho4(:)); 
        res = rho_unsmoothed - rho4;        
        noise(n) = nanstd(res(:)); 
        
        cor(n,1) = nanvar(rho4(:)); 
        A = rho4(:,2:end); 
        B = rho4(:,1:end-1); 
        C = nancov(A(:), B(:)); 
        cor(n,2) = C(1,2);
        A = rho4(2:end,:); 
        B = rho4(1:end-1,:); 
        C = nancov(A(:), B(:)); 
        cor(n,3) = C(1, 2);
        
        cor(n,4) = nanvar(res(:)); 
        A = res(:,2:end); 
        B = res(:,1:end-1); 
        C = nancov(A(:), B(:)); 
        cor(n,5) = C(1, 2);
        A = res(2:end,:); 
        B = res(1:end-1,:); 
        C = nancov(A(:), B(:)); 
        cor(n,6) = C(1, 2);
        
        C = nancov(rho4(:), res(:)); 
        crosscor(n) = C(1, 2);
        
        if isempty(edges)
            [N, edges] = histcounts(res(:), 50);
        else
            N = histcounts(res(:), edges);
        end
        semilogy(edges(2:end), N, '-'); 
        hold on
        grid on
        drawnow; 
    end

    %% 
    figure(3)
    
    plot(log10(-as), sig, 'o-', ...
         log10(-as), noise, 's-', ...
         log10(-as), sig./noise, 'd-'); 
    grid on
    xlabel('SF');
    ylabel('Standard deviation of residual');
    legend('sig', 'noise', 'S/N', 'location', 'best');
    ylim([0 0.1]);
    
    figure(6)
    plot(log10(-as), cor(:,1), 'o-', ...
         log10(-as), cor(:,4), 's-', ...
         log10(-as), cor(:,2)+cor(:,3), 'o-', ...
         log10(-as), cor(:,5)+cor(:,6), 's-'); 
    grid on
    xlabel('SF');
    ylabel('Covariance');
    legend('var(sig)', 'var(noise)', ...
           'cov(sig)', 'cov(noise)', 'location', 'best');
       
       
       
    
    figure(7)
    A = (cor(:,2)+cor(:,3))./cor(:,1); 
    B = (cor(:,5)+cor(:,6))./cor(:,4);
    C = A./B; 
    plot(log10(-as), A, 'o-', ...
         log10(-as), B, 's-', ...
         log10(-as), C, 'x-'); 
    grid on
    xlabel('SF');
    ylabel('Covariance');
    legend('cov(sig)','cov(noise)', 'cov(sig)./cov(noise)', 'location', 'best');
    
    
    figure(8)
    plot(log10(-as), crosscor, 'o-');
    grid on
    xlabel('SF');
    ylabel('Cross correlation');
    
    
    
    
    %%
    
    
    figure(1)
    SFs = linspace(0, 4, 5);
    
    for n = 1:length(SFs)
        subplot(3,4,2+n);
        SF = SFs(n);
        [~, rho3, f3] = SmoothForcFft(M, Ha, Hb, SF);
        rho4 = rho3;
        rho4(~idx) = NaN; 
        
        forc = princeton.unsmoothed; 
        forc.maxHu = forc.maxHu*0.9;
        forc.rho = rho4(1:end-1,1:end-1); 
        [~, h, ax] = PlotFORC(forc);
        
        title(num2str(log10(SF)));
        drawnow
        
        
        subplot(3,4,7+n);
        
        res = rho_unsmoothed - rho4;
        forc_res = forc; 
        forc_res.rho = res(1:end-1,1:end-1);
        [~, h, ax] = PlotFORC(forc_res);
        
        title(['Res ' num2str(log10(SF))]);
        drawnow
    end


