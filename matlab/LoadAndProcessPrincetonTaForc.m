function forc = LoadAndProcessPrincetonTaForc(filename_ts, filename_ta)
 
    k = 1.38e-23;
    mu0 = pi*4e-7;
    tau0 = 1e-9;
        
    forc = LoadRepeatedPrincetonForc(filename_ts); 
    forc.selected = 'TS_FORC';
    t1 = forc.metadata.script.PauseReversal; 
    forc.istaforc = true;
    taforc_temperature = regexp(filename_ts, '[^a-zA-Z0-9]([0-9]+)K\.t[sa]forc', 'tokens');
    if ~isempty(taforc_temperature)
        forc.taforc_temperature = str2double(taforc_temperature{1}{1});
    else
        forc.taforc_temperature = 293;
    end
    T = forc.taforc_temperature; 
    Ms = CalculateMsT(forc.taforc_temperature);
    forc.taforc_Ms = Ms;
%     forc.correctedM = DriftCorrection(forc);
%     forc.grid = RegularizeForcGrid(forc); 
    forc.forc = SmoothForcFft(forc);
    forc.forc.maxHc = round(0.9*forc.forc.maxHc,4);
    forc.forc.maxHu = round(0.9*forc.forc.maxHu,4);
    
    TA_FORC = LoadRepeatedPrincetonForc(filename_ta); 
    t2 = TA_FORC.metadata.script.PauseReversal; 
    TA_FORC.selected = 'TA_FORC';
%     TA_FORC.correctedM = DriftCorrection(TA_FORC);
%     TA_FORC.grid = RegularizeForcGrid(TA_FORC); 
    TA_FORC.forc = SmoothForcFft(TA_FORC, forc.forc.SF);
    TA_FORC.forc.maxHc = round(0.9*TA_FORC.forc.maxHc,4);
    TA_FORC.forc.maxHu = round(0.9*TA_FORC.forc.maxHu,4);
    TA_FORC.taforc_temperature = forc.taforc_temperature;
    TA_FORC.taforc_Ms = forc.taforc_Ms;
    
    Difference = forc; 
    Difference.selected = 'Difference';
    Difference.grid.M = TA_FORC.grid.M - forc.grid.M; 
    Difference.forc = SmoothForcFft(Difference, forc.forc.SF);
    Difference.forc.maxHc = round(0.9*Difference.forc.maxHc,4);
    Difference.forc.maxHu = round(0.9*Difference.forc.maxHu,4);
    
    TA_Distribution_A = Difference;
    TA_Distribution_A.selected = 'TA_Distribution_A';
    TA_Distribution_A.forc = SmoothForcFft(TA_Distribution_A, Difference.forc.SF);
    TA_Distribution_A.forc.maxHc = round(0.9*Difference.forc.maxHc,4);
    TA_Distribution_A.forc.maxHu = round(0.9*Difference.forc.maxHu,4);
    
    TA_Distribution_B = Difference;
    TA_Distribution_B.selected = 'TA_Distribution_B';
    TA_Distribution_B.forc = SmoothForcFft(TA_Distribution_B, Difference.forc.SF);
    TA_Distribution_B.forc.maxHc = round(0.9*Difference.forc.maxHc,4);
    TA_Distribution_B.forc.maxHu = round(0.9*Difference.forc.maxHu,4);
    
    
    TA_Distribution_Anorm = TA_Distribution_A;
    TA_Distribution_Anorm.selected = 'TA_Distribution_Anorm';
    norm = sqrt((2*Ms*k*T)/(mu0*log(t1/tau0)));
    TA_Distribution_Anorm.forc.rho = TA_Distribution_Anorm.forc.rho / norm ./ sqrt(abs(mu0*TA_Distribution_Anorm.forc.Hc));
        
    TA_Distribution_Bnorm = TA_Distribution_B;
    TA_Distribution_Bnorm.selected = 'TA_Distribution_Bnorm';
    norm = sqrt((2*Ms*k*T)/(mu0*log(t1/tau0)));
    TA_Distribution_Bnorm.forc.rho = TA_Distribution_Bnorm.forc.rho / norm ./ sqrt(abs(mu0*TA_Distribution_Bnorm.forc.Hc));
    
    TS_norm = forc;
    TS_norm.selected = 'TS_norm';
    norm = 2*Ms;
    TS_norm.forc.rho = TS_norm.forc.rho / norm;
    
    
    TA_frac_A = TA_Distribution_Anorm;
    TA_frac_A.selected = 'TA_frac_A';
    TA_frac_A.forc.rho = real((TS_norm.forc.rho ./ TA_Distribution_Anorm.forc.rho).^(2/3));
    TA_frac_A.forc.limit = 1e-7;
    
    TA_frac_B = TA_Distribution_Bnorm;
    TA_frac_B.selected = 'TA_frac_B';
    TA_frac_B.forc.rho = real((TS_norm.forc.rho ./ TA_Distribution_Bnorm.forc.rho).^(2/3));
    TA_frac_B.forc.limit = 1e-7;
    
    [V1, HK1] = GetV(TA_Distribution_B.forc.rho, forc.forc.rho, ...
        t1, t2, Ms, forc.forc.Hc, T, tau0);
    V = forc; 
    V.selected = 'V';
    V.forc.rho = V1; 
    V.forc.limit = 1e-10;
    HK = forc; 
    HK.selected = 'HK';
    HK.forc.rho = HK1; 
    HK.forc.limit = 1e11;
    
    forc.TS_FORC = forc;
    forc.TA_FORC = TA_FORC; 
    forc.Difference = Difference;
    forc.TA_Distribution_A = TA_Distribution_A;
    forc.TA_Distribution_B = TA_Distribution_B;
    forc.TA_Distribution_Anorm = TA_Distribution_Anorm;
    forc.TA_Distribution_Bnorm = TA_Distribution_Bnorm;
    forc.TS_norm = TS_norm;
    forc.TA_frac_A = TA_frac_A;
    forc.TA_frac_B = TA_frac_B;
    forc.V = V;
    forc.HK = HK;
end