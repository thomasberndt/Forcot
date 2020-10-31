function forc = LoadAndProcessPrincetonTaForc(filename_ts, filename_ta)

    Ms = 480e3; 
    T = 293;
    k = 1.38e-23;
    mu0 = pi*4e-7;
    t = 1; 
    tau0 = 1e-9;
    
    
    forc = LoadPrincetonForc(filename_ts); 
    forc.selected = 'TS-FORC';
    forc.istaforc = true;
    forc.correctedM = DriftCorrection(forc);
    forc.grid = RegularizeForcGrid(forc); 
    forc.forc = SmoothForcFft(forc);
    forc.forc.maxHc = round(0.9*forc.forc.maxHc,4);
    forc.forc.maxHu = round(0.9*forc.forc.maxHu,4);
    
    ta = LoadPrincetonForc(filename_ta); 
    ta.selected = 'TA-FORC';
    ta.correctedM = DriftCorrection(ta);
    ta.grid = RegularizeForcGrid(ta); 
    ta.forc = SmoothForcFft(ta, forc.forc.SF);
    ta.forc.maxHc = round(0.9*ta.forc.maxHc,4);
    ta.forc.maxHu = round(0.9*ta.forc.maxHu,4);
    
    dif = forc; 
    dif.selected = 'Difference';
    dif.grid.M = ta.grid.M - forc.grid.M; 
    dif.forc = SmoothForcFft(dif, forc.forc.SF);
    dif.forc.maxHc = round(0.9*dif.forc.maxHc,4);
    dif.forc.maxHu = round(0.9*dif.forc.maxHu,4);
    
    tadista = dif;
    tadista.selected = 'TA-Distribution-A';
    tadista.forc = SmoothForcFft(tadista, dif.forc.SF);
    tadista.forc.maxHc = round(0.9*dif.forc.maxHc,4);
    tadista.forc.maxHu = round(0.9*dif.forc.maxHu,4);
    
    tadistb = dif;
    tadistb.selected = 'TA-Distribution-B';
    tadistb.forc = SmoothForcFft(tadistb, dif.forc.SF);
    tadistb.forc.maxHc = round(0.9*dif.forc.maxHc,4);
    tadistb.forc.maxHu = round(0.9*dif.forc.maxHu,4);
    
    
    tadistanorm = tadista;
    tadistanorm.selected = 'TA-Distribution-Anorm';
    norm = sqrt((2*Ms*k*T)/(mu0*log(t/tau0)));
    tadistanorm.forc.rho = tadistanorm.forc.rho / norm ./ sqrt(abs(mu0*tadistanorm.forc.Hc));
    
    tsnorm = forc;
    tsnorm.selected = 'TS-norm';
    norm = 2*Ms;
    tsnorm.forc.rho = tsnorm.forc.rho / norm;
    
    
    tafrac = tadistanorm;
    tafrac.selected = 'TA-frac';
    tafrac.forc.rho = real((tsnorm.forc.rho ./ tadistanorm.forc.rho).^(2/3));
    tafrac.forc.limit = 1e-7;
    
    forc.ts = forc;
    forc.ta = ta; 
    forc.dif = dif;
    forc.tadista = tadista;
    forc.tadistb = tadistb;
    forc.tadistanorm = tadistanorm;
    forc.tsnorm = tsnorm;
    forc.tafrac = tafrac;
end