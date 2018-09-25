function princeton_forc = LoadPrincetonForc(filepath)
% Loads a Princeton VSM FORC file and returns the data in a struct. 
% filename - Optional. File (and path) to the VSM file. If this argument is
% not given, a dialog is shown for the user to open a file. 
% OUTPUT: princeton_forc - struct containing the following fields:
%   princeton_forc.metadata - data about the VSM hardware, and sample
%   description, and measurement settings.
%   princeton_forc.calibration - containing the data points at the
%   calibration field.
%   princeton_forc.measurements - containing the raw FORC data.
%   princeton_forc.filename - the filename as passed in as the argument. 
%   princeton_forc.settings - empty field to set plotting and smoothing
%   settings. 

    if nargin < 1
        [filename, pathname] = uigetfile('../data/forc/*.frc');
        filepath = sprintf('%s/%s', pathname, filename);
    else 
        [pathname,filename,ext] = fileparts(filepath); 
        filename = sprintf('%s%s', filename, ext); 
    end

    col  = 32;
    fid = fopen(filepath); 
    fgetl(fid); 
    fgetl(fid); 
    fgetl(fid); 
    fgetl(fid); 
    line = fgetl(fid); 
    metadata.instrument.Configuration = line(col:end);
    line = fgetl(fid); 
    metadata.instrument.TemperatureControl = line(col:end); 
    line = fgetl(fid); 
    metadata.instrument.HardwareVersion = line(col:end);
    line = fgetl(fid); 
    metadata.instrument.SoftwareVersion = line(col:end);
    line = fgetl(fid); 
    metadata.instrument.UnitsOfMeasure = line(col:end);
    line = fgetl(fid); 
    metadata.instrument.TemperatureIn = line(col:end);
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.sample.Mass = line(col:end);
    line = fgetl(fid); 
    metadata.sample.Volume = line(col:end);
    line = fgetl(fid); 
    metadata.sample.DemagnetizingFactor = line(col:end);
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.settings.FieldRange = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.FieldCommand = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.MomentRange = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.AveragingTime = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.TemperatureCommand = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.TemperatureDifferenceCorrection = line(col:end);
    line = fgetl(fid); 
    metadata.settings.Orientation = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.VibrationAmplitude = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.CalibrationFactor = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.OperatingFrequency = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.settings.SweepMode = line(col:end);
    line = fgetl(fid); 
    metadata.settings.PauseAfterSweepIncrement = str2double(line(col:end));
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.measurement.Description = line(col:end);
    line = fgetl(fid); 
    metadata.measurement.FieldMeasured = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.measurement.TemperatureMeasured = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.measurement.AveragesCompleted = line(col:end);
    line = fgetl(fid); 
    metadata.measurement.MeasuredOn = line(col:end);
    line = fgetl(fid); 
    metadata.measurement.ElapsedTime = str2double(line(col:end));
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.processing.BackgroundSubtraction = line(col:end);
    line = fgetl(fid); 
    metadata.processing.DeltaMProcessing = line(col:end);
    line = fgetl(fid); 
    metadata.processing.DemagnetizingFactor = line(col:end);
    line = fgetl(fid); 
    metadata.processing.Normalization = line(col:end);
    line = fgetl(fid); 
    metadata.processing.NormalizationFactor = line(col:end);
    line = fgetl(fid); 
    metadata.processing.OffsetField = line(col:end);
    line = fgetl(fid); 
    metadata.processing.OffsetMoment = line(col:end);
    line = fgetl(fid); 
    metadata.processing.PoleSaturation = line(col:end);
    line = fgetl(fid); 
    metadata.processing.SlopeCorrection = line(col:end);
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.viewport.Left = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.viewport.Right = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.viewport.Bottom = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.viewport.Top = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.viewport.ShowXaxis = line(col:end);
    line = fgetl(fid); 
    metadata.viewport.ShowYaxis = line(col:end);
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.characterization.InitialSlope = line(col:end);
    line = fgetl(fid); 
    metadata.characterization.Saturation = line(col:end);
    line = fgetl(fid); 
    metadata.characterization.Remanence = line(col:end);
    line = fgetl(fid); 
    metadata.characterization.Coercivity = line(col:end);
    line = fgetl(fid); 
    metadata.characterization.S = line(col:end);
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    metadata.script.AveragingTime = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.Hb1 = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.Hb2 = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.Hc1 = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.Hc2 = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.HCal = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.HNcr = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.HSat = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.NForc = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.PauseCalibration = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.PauseReversal = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.PauseSaturation = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.SlewRate = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.Smoothing = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.IncludesHysteresisLoop = line(col:end);
    line = fgetl(fid); 
    metadata.script.IncludesMsiH = line(col:end);
    line = fgetl(fid); 
    metadata.script.NumberOfSegments = str2double(line(col:end));
    line = fgetl(fid); 
    metadata.script.NumberOfData = str2double(line(col:end));
    
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    line = fgetl(fid); 
    
    
    line = fgetl(fid); 
    is_calibration = 1; 
    
    N = metadata.script.NForc; 
    measurements.M = NaN*zeros(1,N); 
    measurements.Hb = NaN*zeros(1,N); 
    measurements.T = NaN*zeros(1,N); 
    measurements.t = NaN*zeros(1,N); 
    calibration.M = NaN*zeros(1,N); 
    calibration.H = NaN*zeros(1,N); 
    calibration.T = NaN*zeros(1,N); 
    calibration.t = NaN*zeros(1,N); 
    
    n = 0; 
    b = 0;
    time = 0; 
    last_H = 0; 
    t_rev = metadata.script.PauseReversal; 
    t_sat = metadata.script.PauseSaturation;
    t_cal = metadata.script.PauseCalibration; 
    t_avg = metadata.script.AveragingTime; 
    t_slew = metadata.script.SlewRate; 
    t_sat_to_cal = (metadata.script.HSat - metadata.script.HCal) / t_slew; 
    
    while ischar(line) && ~contains(line, 'MicroMag')
        if isempty(line)
            is_calibration = ~is_calibration;
        else
            C = sscanf(line, '%g,%g,%g');
            if is_calibration
                time = time + t_sat + t_sat_to_cal + t_cal; 
                n = n + 1;
                b = 0;
                calibration.H(n) = C(1); 
                calibration.M(n) = C(2); 
                calibration.t(n) = time; 
                if length(C) == 3 
                    calibration.T(n) = C(3); 
                end
                last_H = C(1); 
                time = time + t_rev; 
            else
                time = time + t_slew * abs(last_H - C(1)) + t_avg; 
                last_H = C(1); 
                b = b + 1; 
                if b > size(measurements.M,1) 
                    measurements.M(b,:) = NaN*zeros(1,N); 
                    measurements.Hb(b,:) = NaN*zeros(1,N); 
                    measurements.T(b,:) = NaN*zeros(1,N); 
                    measurements.t(b,:) = NaN*zeros(1,N); 
                end
                measurements.Hb(b,n) = C(1); 
                measurements.M(b,n) = C(2); 
                measurements.t(b,n) = time; 
                if length(C) == 3 
                    measurements.T(b,n) = C(3); 
                end
            end
        end
        
        line = fgetl(fid);
    end
        
    fclose(fid);
        
    measurements.Ha = repmat(measurements.Hb(1,:), size(measurements.Hb,1), 1); 
    measurements.Ha(isnan(measurements.Hb)) = NaN;
    
    measurements.Hc = (measurements.Hb - measurements.Ha)/2; 
    measurements.Hu = (measurements.Hb + measurements.Ha)/2;
    
    princeton_forc.measurements = measurements; 
    princeton_forc.calibration = calibration; 
    princeton_forc.metadata = metadata; 
    princeton_forc.filename = filename; 
    princeton_forc.settings = []; 
end