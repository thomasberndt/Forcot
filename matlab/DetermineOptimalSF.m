function [SF, SFs, PowerSpectrum] = DetermineOptimalSF(f, KX, KY, dHa, dHb)
%         SFs = [0.1:0.1:12]; 
    SFs = round(logspace(-1, 1), 2, 'significant');
    SFs = SFs(end:-1:1);
%         r = linspace(0.2, 1, 35).^3; 
    r = 1./SFs;
    p = zeros(1,length(r)-1);
    num = zeros(1,length(r)-1);
    d = sqrt((KX*dHa).^2+(KY*dHb).^2); 
    for n = 1:length(r)-1
        idx = logical(r(n) <= d & d < r(n+1)); 
        p(n) = log10(mean(abs(f(idx)).^2, 'omitnan')); 
        num(n) = sum(idx(:), "omitnan");
    end
    SFs(end) = []; 
    firstone = find(~isnan(p), 1, 'last'); 
    if p(firstone) < min(p(firstone-3:firstone-1), [], "omitnan")
        p(firstone) = NaN; 
    end
    psmooth = smooth(p, 'rlowess')'; 
    psmooth(isnan(p)) = NaN;
    pp = sort(psmooth, 'desc', 'MissingPlacement', 'last'); 
    [~, ~, bin] = histcounts(psmooth, linspace(min(p, [], "omitnan"), mean(pp(1:3),'omitnan'), 10)); 
    nbin = 1; 
    while ~any(bin==nbin)
        nbin = nbin + 1;
    end
    idx = (bin==nbin); 
    SF = SFs(idx);
    SF = min(SF, [], "omitnan");
    PowerSpectrum = psmooth;
end