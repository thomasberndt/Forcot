function [rho, SF, M, d, ps] = SmoothForcFft(M, Ha, Hb, SF, tatype)
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
    
    if nargin < 5 
        tatype = 'TS-FORC';
    end
    if nargin < 3
        if nargin == 2
            SF = Ha;
        end
        princeton = M; 
        if isfield(princeton, 'istaforc')
            if princeton.istaforc
                if isfield(princeton, 'selected')
                    tatype = princeton.selected;
                end
            end
        end
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
    kx = kx/(dHa*X/1); 
    ky = ky/(dHb*Y/1); 
    [KX, KY] = meshgrid(fftshift(kx), fftshift(ky)); 
    KX = KX';
    KY = KY';
    
    if strcmpi(tatype, 'TA-Distribution-A') 
        f2 = 2i*pi.*KX.*f; 
    elseif strcmpi(tatype, 'TA-Distribution-B') 
        f2 = -2i*pi.*KY.*f; 
    else
        f2 = (2i*pi)^2.*KX.*KY.*f; 
    end
    
    if nargin ~= 2
        SFs = [0.2:0.2:6]; 
        SFs = SFs(end:-1:1);
        r = linspace(0.2, 1, 35).^3; 
        r = 1./SFs;
        p = zeros(1,length(r)-1);
        num = zeros(1,length(r)-1);
        d = sqrt((KX*dHa).^2+(KY*dHb).^2); 
        for n = 1:length(r)-1
            idx = logical(r(n) <= d & d < r(n+1)); 
            p(n) = log10(nanmean(abs(f2(idx)).^2)); 
            num(n) = nansum(idx(:));
        end
        r(end) = []; 
        SFs(end) = []; 
        firstone = find(~isnan(p), 1, 'last'); 
        if p(firstone) < nanmin(p(firstone-3:firstone-1))
            p(firstone) = NaN; 
        end
        psmooth = smooth(p, 'rlowess')'; 
        pp = sort(psmooth, 'desc', 'MissingPlacement', 'last'); 
        [~, ~, bin] = histcounts(psmooth, linspace(nanmin(p), nanmean(pp(1:3)), 10)); 
        nbin = 1; 
        while ~any(bin==nbin)
            nbin = nbin + 1;
        end
        idx = (bin==nbin); 
        SF = SFs(idx);
        SF = nanmin(SF);
        ps = psmooth;
        d = SFs;
    end
    
    filter = exp(-pi^2*SF^2.*((KX*dHa).^2+(KY*dHb).^2)/2); 
%     filter = sech(pi^2*SF^2*((KX*dHa).^2+(KY*dHb).^2));

    f3 = filter.*f2;
    f4 = f3;
    
    M = ifft2(f4); 
    rho = M((end/2+1):(end/2+X1),(end/2-Y1+1):end/2);
    
    if nargin < 3 && nargout == 1
        forc = princeton.grid; 
        forc.rho = rho; 
        forc.M = M; 
        forc.SF = SF; 
        if nargin ~= 2
            forc.SFs = d(end:-1:1);
            forc.PowerSpectrum = ps(end:-1:1);
        end
        idx = GetVisibleForcPart(rho, forc.Hc, forc.Hu, forc.maxHc*1.1, forc.maxHu, 'keepfirstpoint'); 
        forc.rho(~idx) = NaN; 
        rho = forc;
    end
end