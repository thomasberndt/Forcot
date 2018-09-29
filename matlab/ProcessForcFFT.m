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
        
M = princeton.grid.M;
ma = nanmax(M(:)); 
mi = nanmin(M(:)); 
[X1, Y1] = size(M);
M = NaN(2^nextpow2(max(X1,Y1)),2^nextpow2(max(X1,Y1)));
M(1:X1,end-Y1+1:end) = princeton.grid.M; 


for n = 1:size(M, 1)
    f = find(~isnan(M(n,:)), 1, 'first'); 
    if ~isempty(f)
        if f > 1
            M(n,1:f) = linspace(ma, M(n,f), f); 
        end
    end
end
for n = 1:size(M, 1)
    f = find(~isnan(M(n,:)), 1, 'last');
    if ~isempty(f)
        M(n,f:end) = M(n,f); 
    end
end
M(end,:) = M(end-1,:);
f = find(~isnan(M(:,1)), 1, 'last'); 
for n = 1:size(M, 1)
    if isnan(M(n,1))
        M(n,:) = M(f,:);
    end
end

MM = [flipud(M), rot90(M, 2); M, fliplr(M); ]; 

[X, Y] = size(MM);

subplot(2,3,1);
labMM = FourierToLabColors(MM); 
imagesc(MM);

subplot(2,3,4);
f = fft2(MM);
lab = FourierToLabColors(fftshift(f)); 
imagesc(lab);

%%

subplot(2,3,5);
kx = (-X/2):(X/2-1);
ky = (-Y/2):(Y/2-1); 
[KX, KY] = meshgrid(fftshift(kx), fftshift(ky)); 
KX = KX';
KY = KY';

as = logspace(-6, -3, 10);
p  = NaN(size(as));
np = NaN(size(as));

for n = 1:length(as)
    a = as(n);
    filter = exp(-a.*(KX.^2+KY.^2)); 
    f2 = (2i*pi)^2.*KX.*KY.*f; 
    f3 = filter.*f2;
    fn = (1-filter).*f2; 
    power = abs(f3).^2;
    npower = abs(fn).^2; 
    totalpower = abs(f2).^2; 
    tp = sum(totalpower(:));
    p(n) = sum(power(:)); 
    np(n) = sum(npower(:)); 
    lab2 = FourierToLabColors(fftshift(f3)); 
    
    
    subplot(2,3,5);
    imagesc(log10(power));
    
    subplot(2,3,6)
    imagesc(log10(totalpower));
    drawnow
    
   
    subplot(2,3,2);
    M3 = ifft2(f3); 
    rho3 = M3((end/2+1):(end/2+X1),(end/2-Y1+1):end/2);
    forc = princeton.unsmoothed; 
    forc.maxHu = forc.maxHu*0.9;
    forc.rho = rho3(1:end-1,1:end-1); 
    PlotFORC(forc);
    
    subplot(2,3,3);
    semilogx(as, p/tp, 'ob-', as, np/tp, 'or-'); 
    
    
    drawnow
end


%%

subplot(2,3,2);
M3 = ifft2(f3); 
labM3 = FourierToLabColors(M3); 
imagesc(real(M3));



subplot(2,3,3);
    rho3 = M3((end/2+1):(end/2+X1),(end/2-Y1+1):end/2);
labrho = FourierToLabColors(fftshift(rho3)); 
imagesc(real(rho3));
colorbar;



subplot(2,3,6);
imagesc(rho);
colorbar;

clf
    f = princeton.unsmoothed; 
    f.rho = rho3(1:end-1,1:end-1); 

    PlotFORC(princeton.unsmoothed);
    drawnow
    PlotFORC(f);


