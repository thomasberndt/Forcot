function [forcs, Ha, Hb, Hc, Hu, maxHc, maxHu] = LoadForcsForForcPca(files)
    forcs = [];
    for n = 1:length(files)
        princeton = LoadPrincetonForc(files{n}); 
        princeton.correctedM = DriftCorrection(princeton);
        princeton.grid = RegularizeForcGrid(princeton); 
        forcs(:,:,n) = princeton.grid.M; 
        Ha = princeton.grid.Ha; 
        Hb = princeton.grid.Hb; 
        Hc = princeton.grid.Hc; 
        Hu = princeton.grid.Hu; 
        maxHc = princeton.grid.maxHc; 
        maxHu = princeton.grid.maxHu; 
    end
end