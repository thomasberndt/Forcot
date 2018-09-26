function lab = LabColors(L, x)

    if numel(L) == 1
        L = L * ones(size(x)); 
    elseif numel(x) == 1
        x = x * ones(size(L));
    end
    if size(L,1) == 1 && size(L,2) ~= 1
        L = L'; 
    end
    if size(x,1) == 1 && size(x,2) ~= 1
        x = x'; 
    end
    
    N = ndims(L); 
    if N == 2 && size(L, 2) == 1
        N = 1;
    end

    theta = x * 1.7*pi; 
    amp = 50 + L * 60; 
    
    labcolors1 = amp; 
    labcolors2 = (1-abs(50-amp)./60).*(20+50*cos(theta)); 
    labcolors3 = (1-abs(50-amp)./60).*(25+25*sin(theta)); 
    labcolors = cat(N+1, labcolors1, labcolors2, labcolors3); 
    lab = lab2rgb(labcolors); 
    lab(lab>1) = 1;
    lab(lab<0) = 0;
end