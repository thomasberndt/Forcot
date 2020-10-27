function [ts, ta, dif] = LoadAndProcessPrincetonTaForc(filename_ts, filename_ta)
    ts = LoadPrincetonForc(filename_ts); 
    ts.correctedM = DriftCorrection(ts);
    ts.grid = RegularizeForcGrid(ts); 
    ts.forc = SmoothForcFft(ts);
    ts.forc.maxHc = round(0.9*ts.forc.maxHc,4);
    ts.forc.maxHu = round(0.9*ts.forc.maxHu,4);
    
    ta = LoadPrincetonForc(filename_ta); 
    ta.correctedM = DriftCorrection(ta);
    ta.grid = RegularizeForcGrid(ta); 
    ta.forc = SmoothForcFft(ta, ts.forc.SF);
    ta.forc.maxHc = round(0.9*ta.forc.maxHc,4);
    ta.forc.maxHu = round(0.9*ta.forc.maxHu,4);
    
    dif = ts; 
    dif.grid.M = ta.grid.M - ts.grid.M; 
    dif.forc = SmoothForcFft(dif, ts.forc.SF*1.5);
    dif.forc.maxHc = round(0.9*dif.forc.maxHc,4);
    dif.forc.maxHu = round(0.9*dif.forc.maxHu,4);
end