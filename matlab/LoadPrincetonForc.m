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
        [filename, pathname] = uigetfile('../data/*.frc');
        filepath = sprintf('%s/%s', pathname, filename);
    else 
        [pathname,filename,ext] = fileparts(filepath); 
        filename = sprintf('%s%s', filename, ext); 
    end
    
    fid = fopen(filepath); 
    
    firstline = fgetl(fid); 
    if strcmpi(firstline, 'MicroMag 2900/3900 Data File (Series 0015)') || ...
            strcmpi(firstline, 'MicroMag 2900/3900 Data File')
        col = 20;
        fgetl(fid); 
        line = fgetl(fid); 
        metadata.instrument.Configuration = line(col:end);
        line = fgetl(fid); 
        metadata.instrument.HardwareVersion = line(col:end);
        line = fgetl(fid); 
        metadata.instrument.SoftwareVersion = line(col:end);
        line = fgetl(fid); 
        metadata.instrument.UnitsOfMeasure = line(col:end);
        if ~contains(metadata.instrument.Configuration, 'AGM', 'IgnoreCase', true)
            line = fgetl(fid); 
            metadata.instrument.TemperatureIn = line(col:end);
        end
        line = fgetl(fid); 
        metadata.measurement.MeasuredOn = line;
        line = fgetl(fid); 
        metadata.measurement.Description = line;
        
        fgetl(fid); 
        
        col = 18;
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
        
        fgetl(fid); 
        
        line = fgetl(fid); 
        metadata.settings.FieldRange = str2double(line(col:end));
        line = fgetl(fid); 
        metadata.settings.MomentRange = str2double(line(col:end));
        line = fgetl(fid); 
        metadata.measurement.TemperatureMeasured = line(col:end);
        contains_temperature = ~contains(line, 'N/A','IgnoreCase',true); 
        line = fgetl(fid); 
        metadata.settings.Orientation = str2double(line(col:end));
        line = fgetl(fid); 
        metadata.measurement.ElapsedTime = str2double(line(col:end));
        if ~contains(metadata.instrument.Configuration, 'AGM', 'IgnoreCase', true)
            line = fgetl(fid); 
            metadata.processing.SlopeCorrection = line(col:end);
            line = fgetl(fid); 
            metadata.characterization.Saturation = line(col:end);
        end
        line = fgetl(fid); 
        metadata.script.NumberOfData = str2double(line(col:end));

        line = fgetl(fid); 
        
    else
        col  = 32;
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
        if contains(line, 'Pause', 'IgnoreCase', true)
            metadata.settings.PauseAfterSweepIncrement = str2double(line(col:end));
            line = fgetl(fid); 
        end
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

        contains_temperature = contains(line, 'Temperature','IgnoreCase',true); 

        line = fgetl(fid); 
    
    end
    
    is_calibration = 1; 
    
    N = metadata.script.NForc; 
    numdat = metadata.script.NumberOfData;
    maxn1 = (N+.5) - sqrt((N+.5)^2-numdat);
    maxn = ceil(maxn1);
    addone = (maxn1 ~= maxn);
    
    if isnan(N)
        [~, filename, ext] = fileparts(filepath); 
        ME = MException('Forc:InvalidFileFormat', ...
            '%s%s is not a valid Princeton VSM FORC file format', ...
            filename, ext);
        throw(ME);
    end
    measurements.M = NaN*zeros(1,N); 
    measurements.Hb = NaN*zeros(1,N); 
    measurements.T = NaN*zeros(1,N); 
    measurements.t = NaN*zeros(1,N); 
    calibration.M = NaN*zeros(1,N); 
    calibration.H = NaN*zeros(1,N); 
    calibration.T = NaN*zeros(1,N); 
    calibration.t = NaN*zeros(1,N); 
    
    t_rev = metadata.script.PauseReversal; 
    t_sat = metadata.script.PauseSaturation;
    t_cal = metadata.script.PauseCalibration; 
    t_avg = metadata.script.AveragingTime; 
    t_slew = metadata.script.SlewRate; 
    t_sat_to_cal = (metadata.script.HSat - metadata.script.HCal) / t_slew; 
    
    if contains_temperature
        C = fscanf(fid, '%g,%g,%g'); 
        C = reshape(C, 3, [])'; 
    else
        C = fscanf(fid, '%g,%g'); 
        C = reshape(C, 2, [])'; 
    end
    fclose(fid);
    
    n = (1:N)-1; 
    cal = (n.^2 + n + 1)'; 
    cal(maxn+1:end) = cal(maxn) + (1:(N-maxn)) * (maxn * 2 - addone);
    calibration.H = C(cal,1)'; 
    calibration.M = C(cal,2)'; 
    if contains_temperature
        calibration.T = C(cal,3)'; 
    end
    
    measurements.M = NaN((maxn-1) * 2+1-addone, N);
    measurements.Hb = NaN((maxn-1) * 2+1-addone, N);
    measurements.T = NaN((maxn-1) * 2+1-addone, N);
    for k = 1:N
        if k == N
            id = cal(k)+1:numdat;
        else
            id = cal(k)+1:cal(k+1)-1;
        end
        measurements.M(1:length(id),k) = C(id,2); 
        measurements.Hb(1:length(id),k) = C(id,1); 
        if contains_temperature
            measurements.T(1:length(id),k) = C(id,3); 
        end        
    end
    
    dt_cal = t_sat + t_sat_to_cal + t_cal;
    dHb = diff([calibration.H(:)'; measurements.Hb]);
    dt = t_slew * abs(dHb) + t_avg; 
    dt(1,:) = dt(1,:) + t_rev; 
    dt = [dt_cal * ones(1, N); dt]; 
    t = cumsum(dt) + cumsum(nansum(dt)); 
    calibration.t = t(1,:); 
    measurements.t = t(2:end,:);
    
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