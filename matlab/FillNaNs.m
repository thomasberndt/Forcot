function M = FillNaNs(M, method)
    if nargin < 2 
        method = 'extrapolate'; 
    end

    ma = max(M(:), [], 'omitnan'); 
    mi = min(M(:), [], 'omitnan'); 
    
    if strcmpi(method, 'zeros')
        M(isnan(M)) = 0; 
    elseif strcmpi(method, 'mirror')
        for n = 1:size(M, 2)
            f = find(~isnan(M(:,n)), 1, 'first'); 
            if ~isempty(f)
                if f > 1
                    M(1:f-1,n) = M(f,(n+f-1):-1:(n+1)); 
                end
            end
        end
        for n = 1:size(M, 1)
            f = find(~isnan(M(n,:)), 1, 'last');
            if ~isempty(f)
                M(n,f:end) = M(n,f); 
            end
        end

        % M(isnan(M)) = ma; 
        f = find(~isnan(M(1,:)), 1, 'first'); 
        mma = M(1,f);
        for n = 1:size(M, 1)
            f = find(~isnan(M(n,:)), 1, 'first'); 
            if ~isempty(f)
                if f > 1
                    M(n,1:f) = linspace(ma, M(n,f), f); 
                end
            end
        end
        % M(end,:) = M(end-1,:);
        f = find(~isnan(M(:,1)), 1, 'last'); 
        for n = 1:size(M, 1)
            if isnan(M(n,1))
                M(n,:) = M(f,:);
            end
        end
    elseif strcmpi(method, 'extrapolate')
        for n = 1:size(M, 1)
            f = find(~isnan(M(n,:)), 1, 'first'); 
            if ~isempty(f)
                if f > 1
                    M(n,1:f) = linspace(ma, M(n,f), f); 
                end
            end
        end
        for n = 1:size(M, 1)
            f = find(~isnan(M(n,:)), 1, 'last');
            if ~isempty(f)
                M(n,f:end) = M(n,f); 
            end
        end
        M(end,:) = M(end-1,:);
        f = find(~isnan(M(:,1)), 1, 'last'); 
        for n = 1:size(M, 1)
            if isnan(M(n,1))
                M(n,:) = M(f,:);
            end
        end
    elseif strcmpi(method, 'constant')
        for n = 1:size(M, 1)
            f = find(~isnan(M(:,n)), 1, 'first');
            if ~isempty(f)
                M(1:f-1,n) = M(f,n); 
            end
        end
        for n = 1:size(M, 1)
            f = find(~isnan(M(:,n)), 1, 'last');
            if ~isempty(f)
                M(f:end,n) = M(f,n); 
            end
        end
        f = find(~isnan(M(1,:)), 1, 'first');
        for n = 1:f
            M(:,n) = M(:,f);
        end
    elseif strcmpi(method, 'linear')
        e = size(M, 2); 
        for n = 1:e
            f = find(~isnan(M(:,n)), 1, 'first');
            if ~isempty(f)
                dM = M(f+1,n)-M(f,n);
                M(1:f,n) = -dM.*([f:-1:1]'-1) + M(f,n); 
            end
        end
        for n = 1:e
            f = find(~isnan(M(:,n)), 1, 'last');
            if ~isempty(f)
                dM = M(f,n)-M(f-1,n);
                M(f:end,n) = dM.*([0:(e-f)]') + M(f,n); 
            end
        end
        f = find(~isnan(M(1,:)), 1, 'first');
        for n = 1:f
            M(:,n) = M(:,f);
        end
    elseif strcmpi(method, 'quadratic')
        for n = 1:size(M, 2)
            f = find(~isnan(M(:,n)), 1, 'first');
            if ~isempty(f)
                dM = M(f+1,n)-M(f,n);
                x = [1:f]'; 
                M(1:f,n) = dM/(2*f) * (x.^2 - f.^2) + M(f,n);  
            end
        end
        e = size(M, 2); 
        for n = 1:e
            f = find(~isnan(M(:,n)), 1, 'last');
            if ~isempty(f)
                dM = M(f,n)-M(f-1,n);
                x = [f:e]'; 
                M(f:end,n) = dM/(2*(f-e))*(x.^2-f.^2-2*e*(x-f)) + M(f,n); 
            end
        end
        f = find(~isnan(M(1,:)), 1, 'first');
        for n = 1:f
            M(:,n) = M(:,f);
        end
    elseif strcmpi(method, 'cubic')
        M0 = min(M(:), [], 'omitnan'); 
        M1 = max(M(:), [], 'omitnan'); 
        e = size(M, 2);
        for n = 1:e
            f = find(~isnan(M(:,n)), 1, 'first');
            if ~isempty(f)
                dM = M(f+1,n)-M(f,n);
                Mf = M(f,n); 
                x = [1:f]'; 
                y = 0; 
                A = [f^3 f^2 f 1; y^3 y^2 y 1; 3*f^2 2*f 1 0; 3*y^2 2*y 1 0]; 
                v = [M(f,n); M0; dM; 0]; 
                p = A\v;
                M(1:f,n) = polyval(p, x);  
            end
        end
        for n = 1:e
            f = find(~isnan(M(:,n)), 1, 'last');
            if ~isempty(f)
                dM = M(f,n)-M(f-1,n);
                Mf = M(f,n); 
                x = [f:e]'; 
                y = e; 
                A = [f^3 f^2 f 1; y^3 y^2 y 1; 3*f^2 2*f 1 0; 3*y^2 2*y 1 0]; 
                v = [M(f,n); M1; dM; 0]; 
                p = A\v;
                M(f:e,n) = polyval(p, x);  
            end
        end
        f = find(~isnan(M(1,:)), 1, 'first');
        for n = 1:f
            M(:,n) = M(:,f);
        end
    end
end