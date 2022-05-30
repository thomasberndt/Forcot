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
        tatype = 'TS_FORC';
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

    [f, KX, KY, ~, dHa, dHb] = ForcFft(M, Ha, Hb);
    
    if strcmpi(tatype, 'TA_Distribution_A') 
        f2 = 2i*pi.*KX.*f; 
    elseif strcmpi(tatype, 'TA_Distribution_B') 
        f2 = -2i*pi.*KY.*f; 
    else
        f2 = (2i*pi)^2.*KX.*KY.*f; 
    end
    
    if nargin ~= 2
        [SF, SFs, PowerSpectrum]  = DetermineOptimalSF(f2, KX, KY, dHa, dHb);
    end
    
    filter = exp(-pi^2*SF^2.*((KX*dHa).^2+(KY*dHb).^2)/2); 
%     filter = sech(pi^2*SF^2*((KX*dHa).^2+(KY*dHb).^2));

    f3 = filter.*f2;
    f4 = f3;
    
    [X, Y] = size(M);
    M = ifft2(f4); 
    rho = M((end/2+1):(end/2+X),(end/2-Y+1):end/2);
    
    if nargin < 3 && nargout == 1
        forc = princeton.grid; 
        forc.rho = rho; 
        forc.M = M; 
        forc.SF = SF; 
        if nargin ~= 2
            forc.SFs = SFs(end:-1:1);
            forc.PowerSpectrum = PowerSpectrum(end:-1:1);
        end
        idx = GetVisibleForcPart(rho, forc.Hc, forc.Hu, forc.maxHc*1.1, forc.maxHu, 'keepfirstpoint'); 
        forc.rho(~idx) = NaN; 
        rho = forc;
    end
end