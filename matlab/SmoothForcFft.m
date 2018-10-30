function [rho, SF, M] = SmoothForcFft(M, Ha, Hb, SF)
% Smoothes the FORC using FFT algorithm and returns the smooth FORC
% distribution. 
%
% M - FORC on the regularized grid Ha, Hb (matrix)
% Ha, Hb - the grid the measurements are taken on (matrices). 
% OPTIONAL:
% SF - Smoothing Factor (scalar). If not given, optimal SF is determined
% automatically from frequency power spectrum. 
%
% Alternatively, only a princtonforc structure can be passed as the single
% argument. 
%
% OUTPUT: 
% rho - smoothed FORC distribution
% SF - SF that was actually used, i.e. same as input argument if given, or
% optimal SF if not given. 
% M - smoothed FORCs M

    if nargin < 3
        if nargin == 2
            SF = Ha;
        end
        princeton = M; 
        M = princeton.grid.M;
        Ha = princeton.grid.Ha;
        Hb = princeton.grid.Hb;
    end

    dHa = abs(diff(Ha'));
    dHa = nanmean(dHa(:));
    dHb = abs(diff(Hb));
    dHb = nanmean(dHb(:));

    [X1, Y1] = size(M);
    M2 = NaN(2^nextpow2(max(X1,Y1)),2^nextpow2(max(X1,Y1)));
    M2(1:X1,end-Y1+1:end) = M; 

    M2 = FillNaNs(M2);

    MM = [flipud(M2), rot90(M2, 2); M2, fliplr(M2)]; 

    f = fft2(MM);
    [X, Y] = size(f); 
    kx = (-X/2):(X/2-1);
    ky = (-Y/2):(Y/2-1); 
    kx = kx/(dHa*X/2); 
    ky = ky/(dHb*Y/2); 
    [KX, KY] = meshgrid(fftshift(kx), fftshift(ky)); 
    KX = KX';
    KY = KY';
    
    f2 = (2i*pi)^2.*KX.*KY.*f; 
    
    r = linspace(0, 1, 100); 
    p = zeros(length(r)-1,1);
    pfil = zeros(length(r)-1,1); 
    for n = 1:length(r)-1
        d = sqrt((KX*dHa).^2+(KY*dHb).^2); 
        idx = logical(r(n) <= d & d < r(n+1)); 
        p(n) = log10(mean(abs(f2(idx)).^2)); 
    end
    r(end) = []; 
    p(abs(p)==Inf) = NaN;
    [~, pm] = nanmin(p); 
    idx = logical(r>r(pm)*0.5 & r<r(pm)*2);
    pf = polyfit(r(idx), p(idx)', 2); 
    pd = polyder(pf); 
    pm = roots(pd); 
%     plot(r, p, 'o-', r, polyval(pf, r), '-', pm, polyval(pf, pm), 's'); 

    SF = 1./sqrt(2*pm); 
    if isempty(pm)
        [~, pm] = min(p); 
        SF = 1./sqrt(2*r(pm));
    end
    
    filter = exp(-2*pi^2*SF^2.*((KX*dHa).^2+(KY*dHb).^2)); 
%     filter = sech(pi^2*SF^2*((KX*dHa).^2+(KY*dHb).^2));

    f3 = filter.*f2;
    
    
%     r = linspace(0, 1, 100); 
%     pfil = zeros(length(r)-1,1); 
%     for n = 1:length(r)-1
%         d = sqrt((KX*dHa).^2+(KY*dHb).^2); 
%         id = logical(r(n) <= d & d < r(n+1)); 
%         pfil(n) = log10(mean(abs(f3(id)).^2)); 
%     end
%     r(end) = []; 
    
%     plot(r, p, 'o-', r(idx), polyval(pf, r(idx)), '-', ...
%          pm, polyval(pf, pm), 's', r(pfil>0), pfil(pfil>0), 'x-'); 
%     grid on
    
%     fn = (1-filter).*f2; 
%     power = abs(f3).^2;
%     npower = abs(fn).^2; 
%     totalpower = abs(f2).^2; 
%     tp = sum(totalpower(:));
%     p = sum(power(:)); 
%     np = sum(npower(:)); 

    M = ifft2(f3); 
    rho = M((end/2+1):(end/2+X1),(end/2-Y1+1):end/2);
    
    if nargin < 3 && nargout == 1
        forc = princeton.grid; 
        forc.rho = rho; 
        forc.M = M; 
        forc.SF = SF; 
        rho = forc;
    end
end