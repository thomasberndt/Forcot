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
%     end
    
    %%
    clf
    subplot(2,5,1);
    PlotFORC(princeton.unsmoothed);
    drawnow;
        
%     SF = input('SF [%]: ') / 100; 
    
    rho(isnan(rho)) = 0; 

    Na = 2.^nextpow2(size(Ha, 2)); 
    Nb = 2.^nextpow2(size(Hb, 1)); 
    Na = max(Na,Nb);
    Nb = Na; 
    da = nanmean(reshape(diff(Ha,1,2),[],1));
    db = nanmean(reshape(diff(Hb,1,1),[],1));
    a = [-Na/2:Na/2-1];
    b = [-Nb/2:Nb/2-1];
    k = 2*pi/(Na*da) * a;
    j = 2*pi/(Nb*db) * b;
    [J, K] = meshgrid(j, k); 
    [B, A] = meshgrid(b, a); 
    c = b-a;
    u = b+a; 
    C = B-A; 
    U = B+A;
    
    F = fftshift(fft2(rho, Na, Nb));
    
    subplot(2,5,6);
    IM = FourierImage(F);
    image(IM);
    
    %%
    F2 = F; 
    noise = abs(K.*J);
    F2(noise>max(noise(:))*0.01) = 0;
    
    subplot(2,5,7); 
    IM = FourierImage(F2);
    image(IM);
        
    rho2 = ifft2(ifftshift(F2), Na, Nb); 
    rho2 = rho2(1:size(Ha,1),1:size(Ha,2)); 
    
    princeton.smoothed = princeton.unsmoothed; 
    princeton.smoothed.rho = rho2; 
    
    subplot(2,5,2); 
    PlotFORC(princeton.smoothed);
    drawnow;
    
    
    %%
    F2 = F; 
    noise = abs(sqrt((K*da^2+J*db^2).*(K*da^2-J*db^2)));
    F2(noise>max(noise(:))*0.1) = 0;
    
    subplot(2,5,8); 
    IM = FourierImage(F2);
    image(IM);
    
    
    rho2 = ifft2(ifftshift(F2), Na, Nb); 
    rho2 = rho2(1:size(Ha,1),1:size(Ha,2)); 
    
    princeton.smoothed = princeton.unsmoothed; 
    princeton.smoothed.rho = rho2; 
    
    subplot(2,5,3); 
    PlotFORC(princeton.smoothed);
    drawnow;
    
    
    
    %%
    F2 = F; 
    noise = abs(sqrt((K.^2*da^2+J.^2*db^2)));
    F2(noise>max(noise(:))*0.1) = 0;
    
    subplot(2,5,9); 
    IM = FourierImage(F2);
    image(IM);
    
    
    rho2 = ifft2(ifftshift(F2), Na, Nb); 
    rho2 = rho2(1:size(Ha,1),1:size(Ha,2)); 
    
    princeton.smoothed = princeton.unsmoothed; 
    princeton.smoothed.rho = rho2; 
    
    subplot(2,5,4); 
    PlotFORC(princeton.smoothed);
    drawnow;
    
    
    
    %%
    F2 = F; 
    noise1 = abs(K.*J);
    noise2 = abs(sqrt((K*da^2+J*db^2).*(K*da^2-J*db^2)));
    noise3 = abs(sqrt((K.^2*da^2+J.^2*db^2)));
    F2(noise1>max(noise1(:))*0.01 | noise3>max(noise3(:))*0.3) = 0;
    
    subplot(2,5,10); 
    IM = FourierImage(F2);
    image(IM);
    
    
    rho2 = ifft2(ifftshift(F2), Na, Nb); 
    rho2 = rho2(1:size(Ha,1),1:size(Ha,2)); 
    
    princeton.smoothed = princeton.unsmoothed; 
    princeton.smoothed.rho = rho2; 
    
    subplot(2,5,5); 
    PlotFORC(princeton.smoothed);
    drawnow;
    
    
% end



