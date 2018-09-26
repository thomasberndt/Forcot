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
%     clf
    subplot(2,2,1);
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
    C = B-A; 
    U = B+A;
    
    F = fftshift(fft2(rho, Na, Nb));
    
    subplot(2,2,2);
    IM = FourierImage(F);
    image(IM);
    
    %%
    
    SFs = 0:0.1:4; 
    score = NaN(size(SFs));
    for s = 1:length(SFs)
        SF = SFs(s); 

        F2 = F; 
%         noise = abs(C)+abs(U);
        noise = sqrt(C.^2+U.^2);
        noise = sqrt(C.^2+2*U.^2);
        F2(noise/max(noise(:))>0.5^(SF+1)) = 0;
%         F2(abs(C)/max(abs(C(:)))>0.5^(SF+1)) = 0;
%         F2(abs(U)/max(abs(U(:)))>0.5^(SF+1)) = 0;
%         F2(U<-1 & C<0) = 0;
%         F2(U>1 & C>0) = 0;
        
        score(s) = mean(abs(F(F~=0)).^2)-mean(abs(F2(F2~=0)).^2); 
    end
    
    best = find(score<0, 1, 'first');
    if isempty(best)
        SF = SFs(end);
    else
        SF = SFs(best); 
    end
    SF = input(sprintf('SF (%g): ', SF)); 
%     SFs = [0 SF-0.5 SF SF+0.5]; 

    F2 = F; 
%         noise = abs(C)+abs(U);
    noise = sqrt(C.^2+U.^2);
    noise = sqrt(C.^2+2*U.^2);
    F2(noise/max(noise(:))>0.5^(SF+1)) = 0;
%         F2(abs(C)/max(abs(C(:)))>0.5^(SF+1)) = 0;
%         F2(abs(U)/max(abs(U(:)))>0.5^(SF+1)) = 0;
%         F2(U<-1 & C<0) = 0;
%         F2(U>1 & C>0) = 0;        

%         F2(U<-1 & C/max(abs(C(:)))<-0.5^(SF+1)) = 0;
%         F2(U>1 & C/max(abs(C(:)))>0.5^(SF+1)) = 0;
%         F2(abs(F2)/max(abs(F2(:))) < SF) = 0; 

    subplot(2,2,4); 
    IM = FourierImage(F2);
    image(IM);
    BB = length(b);
    axis([0 BB*0.5^(SF+1) BB*(0.5-0.5^(SF+1)) BB*(0.5+0.5^(SF+1))]); 

    rho2 = ifft2(ifftshift(F2), Na, Nb); 
    rho2 = rho2(1:size(Ha,1),1:size(Ha,2)); 

    princeton.smoothed = princeton.unsmoothed; 
    princeton.smoothed.rho = rho2; 

    subplot(2,2,3); 
    PlotFORC(princeton.smoothed);
    drawnow;
    title(num2str(SF));
    
% end



