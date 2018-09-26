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
        princeton1 = LoadPrincetonForc();

        princeton1.correctedM = DriftCorrection(...
                princeton1.measurements.M, princeton1.measurements.t, ...
                princeton1.calibration.M, princeton1.calibration.t);

        princeton1.grid = RegularizeForcGrid(princeton1.correctedM, ...
            princeton1.measurements.Ha, princeton1.measurements.Hb); 
        
        princeton1.unsmoothed = CalculateForc(princeton1.grid); 
        
        rho1 = princeton1.unsmoothed.rho; 
        Ha1 = princeton1.unsmoothed.Ha; 
        Hb1 = princeton1.unsmoothed.Hb; 
        Hc1 = princeton1.unsmoothed.Hc; 
        Hu1 = princeton1.unsmoothed.Hu; 
        
        
        princeton2 = LoadPrincetonForc();

        princeton2.correctedM = DriftCorrection(...
                princeton2.measurements.M, princeton2.measurements.t, ...
                princeton2.calibration.M, princeton2.calibration.t);

        princeton2.grid = RegularizeForcGrid(princeton2.correctedM, ...
            princeton2.measurements.Ha, princeton2.measurements.Hb); 
        
        princeton2.unsmoothed = CalculateForc(princeton2.grid); 
        
        rho2 = princeton2.unsmoothed.rho; 
        Ha2 = princeton2.unsmoothed.Ha; 
        Hb2 = princeton2.unsmoothed.Hb; 
        Hc2 = princeton2.unsmoothed.Hc; 
        Hu2 = princeton2.unsmoothed.Hu; 
%     end
    
    %%
%     clf
    subplot(2,4,1);
    PlotFORC(princeton1.unsmoothed);
    drawnow;
        
%     SF = input('SF [%]: ') / 100; 
    
    rho1(isnan(rho1)) = 0; 
    rho2(isnan(rho2)) = 0; 

    Na = 2.^nextpow2(size(Ha1, 2)); 
    Nb = 2.^nextpow2(size(Hb1, 1)); 
    Na = max(Na,Nb);
    Nb = Na; 
    da = nanmean(reshape(diff(Ha1,1,2),[],1));
    db = nanmean(reshape(diff(Hb1,1,1),[],1));
    a = [-Na/2:Na/2-1];
    b = [-Nb/2:Nb/2-1];
    k = 2*pi/(Na*da) * a;
    j = 2*pi/(Nb*db) * b;
    [J, K] = meshgrid(j, k); 
    [B, A] = meshgrid(b, a); 
    C = B-A; 
    U = B+A;
    
    F1 = fftshift(fft2(rho1, Na, Nb));
    
    subplot(2,4,2);
    IM1 = FourierImage(F1);
    image(IM1);
    
    
    
    
    
    
    subplot(2,4,3);
    PlotFORC(princeton2.unsmoothed);
    drawnow;
    
    F2 = fftshift(fft2(rho2, Na, Nb));
    
    subplot(2,4,4);
    IM2 = FourierImage(F2);
    image(IM2);
    
    
    
    
    
    
    
    
    
    
    
    
    %%
    
    SFs = 0:0.1:4; 
    score = NaN(size(SFs));
    for s = 1:length(SFs)
        SF = SFs(s); 

        Fsmooth = F1; 
%         noise = abs(C)+abs(U);
        noise = sqrt(C.^2+U.^2);
        noise = sqrt(C.^2+2*U.^2);
        Fsmooth(noise/max(noise(:))>0.5^(SF+1)) = 0;
%         F2(abs(C)/max(abs(C(:)))>0.5^(SF+1)) = 0;
%         F2(abs(U)/max(abs(U(:)))>0.5^(SF+1)) = 0;
%         F2(U<-1 & C<0) = 0;
%         F2(U>1 & C>0) = 0;
        
        score(s) = mean(abs(F1(F1~=0)).^2)-mean(abs(Fsmooth(Fsmooth~=0)).^2); 
    end
    
    best = find(score<0, 1, 'first');
    if isempty(best)
        SF = SFs(end);
    else
        SF = SFs(best); 
    end
    SF = input(sprintf('SF (%g): ', SF)); 

    Fsmooth1 = F1; 
    Fsmooth2 = F2; 
    noise = sqrt(C.^2+U.^2);
    noise = sqrt(C.^2+2*U.^2);
    Fsmooth1(noise/max(noise(:))>0.5^(SF+1)) = 0;
    Fsmooth2(noise/max(noise(:))>0.5^(SF+1)) = 0;

    
    
    subplot(2,4,2); 
    IM1 = FourierImage(Fsmooth1);
    image(IM1);
    BB = length(b);
    axis([0 BB*0.5^(SF+1) BB*(0.5-0.5^(SF+1)) BB*(0.5+0.5^(SF+1))]); 
    
    subplot(2,4,4); 
    IM2 = FourierImage(Fsmooth2);
    image(IM2);
    axis([0 BB*0.5^(SF+1) BB*(0.5-0.5^(SF+1)) BB*(0.5+0.5^(SF+1))]); 

    rho1 = ifft2(ifftshift(Fsmooth1), Na, Nb); 
    rho1 = rho1(1:size(Ha1,1),1:size(Ha1,2)); 
    rho2 = ifft2(ifftshift(Fsmooth2), Na, Nb); 
    rho2 = rho2(1:size(Ha1,1),1:size(Ha1,2)); 

    princeton1.smoothed = princeton1.unsmoothed; 
    princeton1.smoothed.rho = rho1; 
    princeton2.smoothed = princeton2.unsmoothed; 
    princeton2.smoothed.rho = rho2; 

    subplot(2,4,1); 
    PlotFORC(princeton1.smoothed);
    drawnow;
    title(num2str(SF));
    
    subplot(2,4,3); 
    PlotFORC(princeton2.smoothed);
    drawnow;
    title(num2str(SF));
    
    
    
    %%
    
    subplot(2,4,6); 
    
    phase = ifftshift(Fsmooth1) .* rot90(ifftshift(Fsmooth2),2); 
    phase = fftshift(phase);
    IMphase = FourierImage(phase);
    image(IMphase);
    axis([0 BB*0.5^(SF+1) BB*(0.5-0.5^(SF+1)) BB*(0.5+0.5^(SF+1))]); 
    
    
    subplot(2,4,5); 
    C = ifft2(ifftshift(phase), Na, Nb); 
    C = C(1:size(Ha1,1),1:size(Ha1,2)); 
    cc = princeton1.unsmoothed; 
    cc.rho = real(C); 
    PlotFORC(cc);
    drawnow;
    
    
% end



