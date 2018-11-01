function princeton = LoadAndProcessPrincetonForc(filename)
    princeton = LoadPrincetonForc(filename); 
    princeton.correctedM = DriftCorrection(princeton);
    princeton.grid = RegularizeForcGrid(princeton); 
    princeton.forc = SmoothForcFft(princeton);
    princeton.forc.maxHc = 0.9*princeton.forc.maxHc;
    princeton.forc.maxHu = 0.9*princeton.forc.maxHu;
end