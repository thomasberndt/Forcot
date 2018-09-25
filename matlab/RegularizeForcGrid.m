function grid = RegularizeForcGrid(M, Ha, Hb)
% Takes measurements M measured on an irrgular grid Ha, Hb and interpolates
% it onto a regular grid. This is necessary as the VSM does not usually
% take the measurements at the exact field points, so some slight variation
% is expected.
%
% M - raw measurements (matrix) taken on an irregular grid Ha, Hb
% Ha, Hb - the irregular grid the measurements are taken on (matrices). 
%
% OUTPUT: 
% grid - a structure containing the regularized grid & measurements:
%   grid.M - measurements (matrix) on a regular grid.
%   grid.Ha, grid.Hb - the regular grid (matrices).

    Ha_space = linspace(Hb(1,1), Hb(1, end), round(size(Hb,2))); 
    Hb_space = linspace(Hb(1, end), max(Hb(end,:)), round(size(Hb,1))); 
    [grid.Ha, grid.Hb] = meshgrid(Ha_space, Hb_space); 
    grid.Hc = (grid.Hb - grid.Ha)/2; 
    grid.Hu = (grid.Hb + grid.Ha)/2;
    
    idx = ~isnan(Hb); 
    idx = idx(:);
    
    f = scatteredInterpolant(Ha(idx), Hb(idx), M(idx), ...
        'natural', 'none'); 
    grid.M = f(grid.Ha, grid.Hb); 
    grid.Ha(isnan(grid.M)) = NaN; 
    grid.Hb(isnan(grid.M)) = NaN; 
end