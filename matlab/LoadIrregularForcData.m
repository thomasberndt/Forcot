function [Ha, Hb, M, Ha_cal, Hb_cal, M_cal, N, N_b] = LoadIrregularForcData(fid)
    last_Ha = NaN; 
    Ha_cal = [];
    Hb_cal = [];
    M_cal = []; 
    Ha = [];
    Hb = []; 
    M = [];
    k = 1;
    N = 1;
    N_b = 0; 
    line = fgetl(fid);  
    while ~contains(line, 'MicroMag') && ...
          ~contains(line, 'ends')
        % Calibration
        C = sscanf(line, '%g,%g');
        if isnan(last_Ha)
            last_Ha = C(1);
        end
        Ha_cal(N) = last_Ha;
        Hb_cal(N) = C(1); 
        M_cal(N) = C(2);
        line = fgetl(fid);  % Empty Line
        
        % First measurement (i.e., Ha)
        line = fgetl(fid);          
        C = sscanf(line, '%g,%g');
        last_Ha = C(1); 
        Ha(k) = last_Ha; 
        Hb(k) = C(1); 
        M(k) = C(2); 
        k = k + 1;
        
        % Following lines (i.e., Hb) 
        line = fgetl(fid); 
        last_k = 0;
        while ischar(line) && ...
                ~contains(line, 'MicroMag') && ...
                ~contains(line, 'ends') && ...
                ~isempty(line)
            C = sscanf(line, '%g,%g');
            Ha(k) = last_Ha; 
            Hb(k) = C(1); 
            M(k) = C(2); 
            line = fgetl(fid); 
            k = k + 1;
            last_k = last_k + 1; 
        end
        if last_k > N_b
            N_b = last_k;
        end
        line = fgetl(fid);  % Empty Line
        N = N + 1;
    end
    
end