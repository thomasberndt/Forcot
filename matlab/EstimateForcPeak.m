function limit = EstimateForcPeak(rho, Hc, Hu, maxHc, maxHu) 
% Estimates the peak of the FORC that should be used for normalization. 
% rho - The FORC distribution (matrix)
% Hc, Hu - the grid of the FORC distribution (matrices)
% maxHc, maxHu - maximum values of Hc and Hu that are to be plotted
%
% OUTPUT: 
% limit - returns the suggested peak. 
    f = rho(GetVisibleForcPart(rho, Hc, Hu, maxHc, maxHu, 'cropcorner'));
    if isempty(f)
        limit = nanmax(abs(rho));
    else
        limit = nanmax(abs(f)); 
    end
end