function princeton = LoadAndProcessPrincetonForc(filename, repeated)
    if nargin < 2
        repeated = true;
    end
    
    if repeated 
        princeton = LoadRepeatedPrincetonForc(filename);
    else
        princeton = LoadPrincetonForc(filename); 
        princeton.correctedM = DriftCorrection(princeton);
        princeton.grid = RegularizeForcGrid(princeton); 
    end

    princeton.forc = SmoothForcFft(princeton);
    princeton.forc.maxHc = round(0.9*princeton.forc.maxHc,4);
    princeton.forc.maxHu = round(0.9*princeton.forc.maxHu,4);
end