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
    
    calibration = []; 
    metadata = []; 
    metadata.IrregularGrid = false;
    
    firstline = fgetl(fid); 
    if count(firstline, ',') > 20
        % Assume this is a csv file
        fclose(fid);
        data = csvread(filepath);
        unitsH = 1e-3; 
        unitsM = 1e-3; 
        measurements.M = data(:,2:2:end) * unitsM; 
        measurements.Hb = data(:,1:2:end) * unitsH; 
        measurements.Ha = repmat(measurements.Hb(1,:), size(measurements.Hb, 1), 1); 
        measurements.T = NaN*zeros(size(measurements.M)); 
        measurements.t = NaN*zeros(size(measurements.M)); 
        metadata.script.PauseReversal = 0.12;
        if strcmpi(ext, 'taforc')
            metadata.script.PauseReversal = 200;
        end
    else 
        if startsWith(firstline, 'VFTB', 'IgnoreCase',true) ||...
                strcmpi(firstline, 'MicroMag 2900/3900 Data File (Series 0015)') || ...
                strcmpi(firstline, 'MicroMag 2900/3900 Data File') || ...
                strcmpi(firstline, 'MicroMag 2900/3900 Data File (Series 0015)First-order reversal curves')
            % This is a Princeton file
            col = 20;
            if ~strcmpi(firstline, 'MicroMag 2900/3900 Data File (Series 0015)First-order reversal curves')
                fgetl(fid); 
            end
            line = fgetl(fid); 
            metadata.instrument.Configuration = line(col:end);
            line = fgetl(fid); 
            metadata.instrument.HardwareVersion = line(col:end);
            line = fgetl(fid); 
            metadata.instrument.SoftwareVersion = line(col:end);
            line = fgetl(fid); 
            metadata.instrument.UnitsOfMeasure = line(col:end);
            if strcmpi(metadata.instrument.UnitsOfMeasure, 'cgs')
                unitsH = 1e-4; 
                unitsM = 1e-3; 
            else
                unitsH = 1;
                unitsM = 1; 
            end
            line = fgetl(fid); 
            if contains(line, 'Temperature', 'IgnoreCase', true)
                metadata.instrument.TemperatureIn = line(col:end);
                line = fgetl(fid); 
            end
            metadata.measurement.MeasuredOn = line;
            line = fgetl(fid); 
            metadata.measurement.Description = line;

            line = fgetl(fid); 

            col = 18;
            if ~contains(line, 'time', 'IgnoreCase', true)
                line = fgetl(fid); 
            end
            metadata.script.AveragingTime = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.script.Hb1 = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.Hb2 = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.Hc1 = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.Hc2 = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.HCal = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.HNcr = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.script.HSat = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.NForc = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.script.PauseCalibration = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.script.PauseReversal = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.script.PauseSaturation = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.script.SlewRate = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.script.Smoothing = str2double(line(col:end));

            fgetl(fid); 

            line = fgetl(fid); 
            metadata.settings.FieldRange = str2double(line(col:end)) * unitsH;
            line = fgetl(fid); 
            metadata.settings.MomentRange = str2double(line(col:end)) * unitsM;
            line = fgetl(fid); 
            metadata.measurement.TemperatureMeasured = line(col:end);
            contains_temperature = ~contains(line, 'N/A','IgnoreCase',true); 
            line = fgetl(fid); 
            metadata.settings.Orientation = str2double(line(col:end));
            line = fgetl(fid); 
            metadata.measurement.ElapsedTime = str2double(line(col:end));
            line = fgetl(fid);
            if contains(line, 'Slope cor', 'IgnoreCase', true)             
                metadata.processing.SlopeCorrection = line(col:end) * unitsH;
                line = fgetl(fid); 
            end
            if contains(line, 'Saturation', 'IgnoreCase', true) 
                metadata.characterization.Saturation = line(col:end) * unitsM;
                line = fgetl(fid); 
            end
            metadata.script.NumberOfData = str2double(line(col:end));

            line = fgetl(fid); 

        else
            col  = 32;        
            line = fgetl(fid); 
            line = fgetl(fid); 
            if startsWith(line, 'Generated by Lake Shore 8600 series VSM software version 1.', 'IgnoreCase',true)
                fgetl(fid); 
                fgetl(fid); 
                line = fgetl(fid); 
                s = split(line);
                metadata.instrument.Configuration = s{end};
                line = fgetl(fid); 
                s = split(line);
                metadata.instrument.TemperatureControl = s{end};
                line = fgetl(fid); 
                s = split(line);
                metadata.instrument.UnitsOfMeasure = s{end};
                if strcmpi(metadata.instrument.UnitsOfMeasure, 'cgs')
                    unitsH = 1e-4; 
                    unitsM = 1e-3; 
                else
                    unitsH = 1;
                    unitsM = 1; 
                end
                line = fgetl(fid); 
                s = split(line);
                metadata.instrument.TemperatureIn = s{end};
                fgetl(fid);
                fgetl(fid); 

                line = fgetl(fid); 
                s = split(line);
                metadata.script.AveragingTime = str2double(s{end});
                line = fgetl(fid); 
                s = split(line);
                metadata.script.Hb1 = str2double(s{end}) * unitsH;
                line = fgetl(fid); 
                s = split(line);
                metadata.script.Hb2 = str2double(s{end}) * unitsH;
                line = fgetl(fid); 
                s = split(line);
                metadata.script.Hc2 = str2double(s{end}) * unitsH;
                line = fgetl(fid); 
                s = split(line);
                metadata.script.HCal = str2double(s{end}) * unitsH;
                line = fgetl(fid); 
                s = split(line);
                metadata.script.HSat = str2double(s{end}) * unitsH;
                line = fgetl(fid); 
                s = split(line);
                metadata.script.NForc = str2double(s{end});
                line = fgetl(fid); 
                s = split(line);
                metadata.script.PauseCalibration = str2double(s{end});
                line = fgetl(fid); 
                s = split(line);
                metadata.script.PauseReversal = str2double(s{end});
                line = fgetl(fid); 
                s = split(line);
                metadata.script.PauseSaturation = str2double(s{end});
                line = fgetl(fid); 
                s = split(line);
                metadata.script.SlewRate = str2double(s{end}) * unitsH;
                line = fgetl(fid); 
                s = split(line);
                metadata.script.Smoothing = str2double(s{end});
                line = fgetl(fid); 
                s = split(line);
                metadata.script.IncludesHysteresisLoop = s{end};

                line = fgetl(fid); 
                line = fgetl(fid); 
                contains_temperature = contains(line, 'Temperature','IgnoreCase',true); 
                line = fgetl(fid); 
            else

                while ~contains(line, 'Configuration', 'IgnoreCase', true) 
                    line = fgetl(fid); 
                end
                metadata.instrument.Configuration = line(col:end);
                line = fgetl(fid); 
                metadata.instrument.TemperatureControl = line(col:end); 
                line = fgetl(fid); 
                metadata.instrument.HardwareVersion = line(col:end);
                line = fgetl(fid); 
                metadata.instrument.SoftwareVersion = line(col:end);
                line = fgetl(fid); 
                metadata.instrument.UnitsOfMeasure = strtrim(line(col:end));
                if strcmpi(metadata.instrument.UnitsOfMeasure, 'cgs')
                    unitsH = 1e-4; 
                    unitsM = 1e-3; 
                else
                    unitsH = 1;
                    unitsM = 1; 
                end
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
                metadata.settings.FieldRange = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.settings.FieldCommand = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.settings.MomentRange = str2double(line(col:end)) * unitsM;
                line = fgetl(fid); 
                metadata.settings.AveragingTime = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.settings.TemperatureCommand = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.settings.TemperatureDifferenceCorrection = line(col:end);
                line = fgetl(fid); 
                metadata.settings.Orientation = str2double(line(col:end));
                line = fgetl(fid); 
                if contains(line, 'Gradient', 'IgnoreCase', true) 
                    metadata.settings.Gradient = line(col:end);
                    line = fgetl(fid); 
                end
                if contains(line, 'Probe factor', 'IgnoreCase', true) 
                    metadata.settings.ProbeFactor = line(col:end);
                    line = fgetl(fid); 
                end
                if contains(line, 'Probe Q', 'IgnoreCase', true) 
                    metadata.settings.ProbeQ = line(col:end);
                    line = fgetl(fid); 
                end
                if contains(line, 'Probe resonance', 'IgnoreCase', true) 
                    metadata.settings.ProbeResonance = line(col:end);
                    line = fgetl(fid); 
                end        
                if contains(line, 'Operating frequency', 'IgnoreCase', true) 
                    metadata.settings.OperatingFrequency = str2double(line(col:end));
                    line = fgetl(fid); 
                end
                if contains(line, 'Vibration amplitude', 'IgnoreCase', true) 
                    metadata.settings.VibrationAmplitude = line(col:end);
                    line = fgetl(fid); 
                end        
                if contains(line, 'Calibration factor', 'IgnoreCase', true) 
                    metadata.settings.CalibrationFactor = str2double(line(col:end));
                    line = fgetl(fid); 
                end
                if contains(line, 'Operating frequency', 'IgnoreCase', true) 
                    metadata.settings.OperatingFrequency = str2double(line(col:end));
                    line = fgetl(fid); 
                end
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
                metadata.measurement.FieldMeasured = str2double(line(col:end)) * unitsH;
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
                metadata.script.Hb1 = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.script.Hb2 = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.script.Hc1 = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.script.Hc2 = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.script.HCal = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.script.HNcr = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.script.HSat = str2double(line(col:end)) * unitsH;
                line = fgetl(fid); 
                metadata.script.NForc = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.script.PauseCalibration = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.script.PauseReversal = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.script.PauseSaturation = str2double(line(col:end));
                line = fgetl(fid); 
                metadata.script.SlewRate = str2double(line(col:end)) * unitsH;
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

        end

        N = metadata.script.NForc; 
        if ~contains(metadata.instrument.Configuration, 'AGM', 'IgnoreCase', true)
             Nsmooth = 0; 
        else
             Nsmooth = metadata.script.Smoothing; 
        end

        N2 = N;
        if isnan(N2)
            % VFTB format does not contain information on how many loops
            % were measured. These need to be determined manually by
            % counting the lines in the file. Also, the grid may not be
            % regular.
%             [~, filename, ext] = fileparts(filepath); 
%             ME = MException('Forc:InvalidFileFormat', ...
%                 '%s%s is not a valid Princeton VSM FORC file format', ...
%                 filename, ext);
%             throw(ME);
            N2 = 2;
            metadata.IrregularGrid = true;
        end
        measurements.M = NaN*zeros(1,N2); 
        measurements.Hb = NaN*zeros(1,N2); 
        measurements.T = NaN*zeros(1,N2); 
        measurements.t = NaN*zeros(1,N2); 
        calibration.M = NaN*zeros(1,N2); 
        calibration.H = NaN*zeros(1,N2); 
        calibration.T = NaN*zeros(1,N2); 
        calibration.t = NaN*zeros(1,N2); 

        t_rev = metadata.script.PauseReversal; 
        t_sat = metadata.script.PauseSaturation;
        t_cal = metadata.script.PauseCalibration; 
        t_avg = metadata.script.AveragingTime; 
        t_slew = metadata.script.SlewRate; 
        t_sat_to_cal = (metadata.script.HSat - metadata.script.HCal) / t_slew; 


        if contains_temperature
            line = fgetl(fid); 
            C1 = transpose(sscanf(line, '%g,%g,%g'));
            line = fgetl(fid);
            line = fgetl(fid);  
            k = 1;

            while ischar(line) && ~contains(line, 'MicroMag') && ~isempty(line)
                k = k + 1;
                C1(k,:) = transpose(sscanf(line, '%g,%g,%g'));
                line = fgetl(fid); 
            end

            C = fscanf(fid, '%g,%g,%g'); 
            C = reshape(C, 3, [])'; 
        else
            if metadata.IrregularGrid
                % VFTB may have a slightly non-regular grid
                [Ha, Hb, M, Ha_cal, Hb_cal, M_cal, N2, N_b] = LoadIrregularForcData(fid);
            else                
                line = fgetl(fid); 
                C1 = transpose(sscanf(line, '%g,%g'));
                line = fgetl(fid);
                line = fgetl(fid);  
                k = 1;
                while ischar(line) && ...
                        ~contains(line, 'MicroMag') && ...
                        ~contains(line, 'ends') && ...
                        ~isempty(line)
                    k = k + 1;
                    C1(k,:) = transpose(sscanf(line, '%g,%g'));
                    line = fgetl(fid); 
                end

                C = fscanf(fid, '%g,%g'); 
                C = reshape(C, 2, [])'; 
            end
        end
        fclose(fid);
        
        if ~metadata.IrregularGrid
            n = (1:N)-1; 
            a1 = size(C1,1)-1; 
            C = [C1; C]; 
            numdat = length(C(:,1));
            maxn1 = (N+.5) - sqrt((N+.5)^2-numdat+N*(a1-1));
            maxn2 = N - sqrt(N^2-numdat+N*a1);
            if abs(maxn1-round(maxn1))>abs(maxn2-round(maxn2))
                maxn = maxn2;
                addone = 0;
            else
                maxn = maxn1; 
                addone = 1;
            end
            cal = transpose(n.*(a1+n))+1;
            cal2 = transpose(maxn*(maxn+a1)+(n-maxn).*(a1+2*maxn-addone)) + 1;
            cal(n>=maxn) = cal2(n>=maxn);

            calibration.H = C(cal,1)' * unitsH; 
            calibration.M = C(cal,2)' * unitsM; 
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
                measurements.M(1:length(id),k) = C(id,2) * unitsM; 
                measurements.Hb(1:length(id),k) = C(id,1) * unitsH; 
                if contains_temperature
                    measurements.T(1:length(id),k) = C(id,3); 
                end        
            end

            dt_cal = t_sat + t_sat_to_cal + t_cal;
            dHb = diff([calibration.H(:)'; measurements.Hb]);
            dt = t_slew * abs(dHb) + t_avg; 
            dt(1,:) = dt(1,:) + t_rev; 
            dt = [dt_cal * ones(1, N); dt]; 
            t = cumsum(dt) + cumsum(sum(dt, 'omitnan')); 
            calibration.t = t(1,:); 
            measurements.t = t(2:end,:);

            measurements.Ha = repmat(measurements.Hb(1,:), size(measurements.Hb,1), 1); 
            measurements.Ha(isnan(measurements.Hb)) = NaN;
        else
            % VFTB may have a slightly non-regular grid
            f = scatteredInterpolant(Ha', Hb', M'); 
            [measurements.Ha, measurements.Hb] = meshgrid(...
                linspace(max(Ha), min(Ha), N2), ...
                linspace(min(Hb), max(Hb), N_b));
            measurements.M = f(measurements.Ha, measurements.Hb) * unitsM;
            measurements.Ha = measurements.Ha * unitsH;
            measurements.Hb = measurements.Hb * unitsH;
            calibration = [];
        end
        measurements.Hc = (measurements.Hb - measurements.Ha)/2; 
        measurements.Hu = (measurements.Hb + measurements.Ha)/2;
    end
    
    princeton_forc.measurements = measurements; 
    princeton_forc.calibration = calibration; 
    princeton_forc.metadata = metadata; 
    princeton_forc.filename = filename; 
    princeton_forc.settings = []; 
    princeton_forc.istaforc = false;
end