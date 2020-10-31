function princeton = LoadAndProcessPrincetonForc(filename)
    princeton = LoadPrincetonForc(filename); 
    princeton.istaforc = false;
    princeton.correctedM = DriftCorrection(princeton);
    princeton.grid = RegularizeForcGrid(princeton); 
    princeton.forc = SmoothForcFft(princeton);
    princeton.forc.maxHc = round(0.9*princeton.forc.maxHc,4);
    princeton.forc.maxHu = round(0.9*princeton.forc.maxHu,4);
end