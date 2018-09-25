function correctedM = DriftCorrection(M, t, calibration_M, calibration_t)
% Applied the drift correction to M, taking into account the times at which
% the calibration field was measured. 
% M - measurements (vector). 
% t - times at which measurements are taken (vector).
% calibration_M - calibration measurements (vector).
% calibration_t - times at which calibration measurements are taken
% (vector).
%
% OUTPUT:
% correctedM - dirft corrected measurements (vector). 
    f = fit(calibration_t', calibration_M' - mean(calibration_M),  ...
            'smoothingspline', 'SmoothingParam', 1e-8);
    cor = reshape(feval(f, t), size(t)); 
    correctedM = M - cor;
end