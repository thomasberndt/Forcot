function princeton = LoadRepeatedPrincetonForc(filename)
% Loads a repeatedly measured Princeton FORC file (extensions .000, .001,
% etc)
    repeated_measured = GetRepeatedlyMeasuredForc(filename);

    rep_princetons = cell([length(repeated_measured),1]);
    for n = 1:length(repeated_measured)
        rep_princetons{n} = LoadPrincetonForc(repeated_measured{n}); 
        rep_princetons{n}.correctedM = DriftCorrection(rep_princetons{n});
        rep_princetons{n}.grid = RegularizeForcGrid(rep_princetons{n}); 
    end

    princeton = AverageOfRepeatedForcs(rep_princetons);
end