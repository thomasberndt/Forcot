function forc = CalculateForc(grid)
    [forc.rho, forc.Hc, forc.Hu] = MixedDerivative(grid.M, grid.Hc, grid.Hu);
    Hcs = forc.Hc(~isnan(forc.rho)); 
    Hus = forc.Hu(~isnan(forc.rho)); 
    forc.Ha = forc.Hu - forc.Hc; 
    forc.Hb = forc.Hu + forc.Hc; 
    forc.maxHc = max(Hcs(:)); 
    forc.maxHu = max(Hus(:)); 
end