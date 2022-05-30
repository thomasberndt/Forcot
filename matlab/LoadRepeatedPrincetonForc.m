function princeton = LoadRepeatedPrincetonForc(filename, calibration_factor)
% Loads a repeatedly measured Princeton FORC file (extensions .000, .001,
% etc)
    if nargin < 2
        calibration_factor = []; 
    end
    repeated_measured = GetRepeatedlyMeasuredForc(filename);

    rep_princetons = cell([length(repeated_measured),1]);
    for n = 1:length(repeated_measured)
        rep_princetons{n} = LoadPrincetonForc(repeated_measured{n}); 
        rep_princetons{n}.correctedM = DriftCorrection(rep_princetons{n});
        if isempty(calibration_factor)
            rep_princetons{n}.correctedM = rep_princetons{n}.correctedM / ...
                rep_princetons{n}.calibration.M(1) * rep_princetons{1}.calibration.M(1);
        else
            rep_princetons{n}.correctedM = rep_princetons{n}.correctedM / ...
                rep_princetons{n}.calibration.M(1) * calibration_factor;
        end
        rep_princetons{n}.grid = RegularizeForcGrid(rep_princetons{n}); 
    end

    princeton = AverageOfRepeatedForcs(rep_princetons);
end