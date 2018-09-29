function M = FillNaNs(M)
    ma = nanmax(M(:)); 
    mi = nanmin(M(:)); 
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
end