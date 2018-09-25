function limit = EstimateForcPeak(rho, Hc, Hu, maxHc, maxHu) 
% Estimates the peak of the FORC that should be used for normalization. 
% rho - The FORC distribution (matrix)
% Hc, Hu - the grid of the FORC distribution (matrices)
% maxHc, maxHu - maximum values of Hc and Hu that are to be plotted
%
% OUTPUT: 
% limit - returns the suggested peak. 
    minHc = 0.002;
    f = rho(~isnan(rho) ...
                & Hc-minHc>0 ...
                & Hc-minHc>-Hu ...
                & Hc<maxHc ...
                & abs(Hu)<maxHu);
    limit = max(abs(f)); 
end