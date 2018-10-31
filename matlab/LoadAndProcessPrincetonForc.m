function princeton = LoadAndProcessPrincetonForc(filename)
    tic
    princeton = LoadPrincetonForc(filename); 
    toc
    princeton.correctedM = DriftCorrection(princeton);
    toc
    princeton.grid = RegularizeForcGrid(princeton); 
    toc
    princeton.forc = SmoothForcFft(princeton);
    toc
    princeton.forc.maxHc = 0.9*princeton.forc.maxHc;
    princeton.forc.maxHu = 0.9*princeton.forc.maxHu;
    toc
end