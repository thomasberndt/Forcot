function grid = RegularizeForcGrid(M, Ha, Hb)
% Takes measurements M measured on an irrgular grid Ha, Hb and interpolates
% it onto a regular grid. This is necessary as the VSM does not usually
% take the measurements at the exact field points, so some slight variation
% is expected.
%
% M - raw measurements (matrix) taken on an irregular grid Ha, Hb
% Ha, Hb - the irregular grid the measurements are taken on (matrices). 
%
% Alternatively, only a princtonforc structure can be passed as the single
% argument. 
%
% OUTPUT: 
% grid - a structure containing the regularized grid & measurements:
%   grid.M - measurements (matrix) on a regular grid.
%   grid.Ha, grid.Hb - the regular grid (matrices).
    if nargin == 1
        princeton = M; 
        M = princeton.correctedM; 
        Ha = princeton.measurements.Ha; 
        Hb = princeton.measurements.Hb; 
        if princeton.metadata.IrregularGrid
            grid.Ha = Ha;
            grid.Hb = Hb;
            grid.M = M; 
            grid.Hc = (grid.Hb - grid.Ha)/2; 
            grid.Hu = (grid.Hb + grid.Ha)/2;
            Hcs = grid.Hc(~isnan(grid.M)); 
            Hus = grid.Hu(~isnan(grid.M)); 
            grid.maxHc = max(Hcs(:)); 
            grid.maxHu = max(Hus(:)); 
            return
        end
    end
    
    Ha_space = linspace(Hb(1,1), Hb(1, end), round(size(Hb,2))); 
    Hb_space = linspace(Hb(1, end), max(Hb(end,:)), round(size(Hb,1))); 
    [grid.Ha, grid.Hb] = meshgrid(Ha_space, Hb_space); 
    grid.Hc = (grid.Hb - grid.Ha)/2; 
    grid.Hu = (grid.Hb + grid.Ha)/2;
    
    idx = ~isnan(Hb); 
    idx = idx(:);
    Has = Ha(1,:);
    problem = find(diff(Has) > 0) + 1;
    Has(problem) = (Has(problem+1) + Has(problem-1)) / 2; 
    N = floor(size(Ha,1)/2); 
    N2 = floor(size(Ha,1)+N-size(Ha,2)+1); 
%     Hbs = [Hb(:,end); Hb(N2+1:end,N+1)]; 
    Hbs = [Hb(1,end:-1:(N+2))'; Hb(:,N+1)];
    if any(isnan(Hbs))
        Hbs = Hbs(1:find(isnan(Hbs))-1);
    end
    problem = find(diff(Hbs) < 0);
    Hbs(problem) = (Hbs(problem+1) + Hbs(problem-1)) / 2; 
    [HA, HB] = meshgrid(Has, Hbs); 
    regM = NaN(sum(size(M)), size(Hb, 2));
%     regHa = [];
%     regHb = [];
    for n = 1:size(Hb, 2)
%         regHa(:,n) = [Ha(1,n)*ones(size(M,2)-n,1); Ha(:,n); Ha(1,n)*ones(n,1)];
%         regHa(isnan(regHa(:,n)),n) = Ha(1,n);
%         regHb(:,n) = [Hb(1:(size(M,2)-n),end); Hb(:,n); zeros(n,1)];
        regM(:,n) = [NaN(size(M,2)-n,1); M(:,n); NaN(n,1)];
    end
%     regM = regM(1:length(Hbs),:); 
    regM = regM(1:(size(regM,1)-N-1),:); 
%     f = scatteredInterpolant(HB(~isnan(regM)), HA(~isnan(regM)), regM(~isnan(regM)),  'linear', 'none');
    if size(regM, 1) > size(HB, 1)
        regM = regM(1:size(HB, 1),:);
    end

    HA = fliplr(HA); 
    HB = fliplr(HB); 
    regM = fliplr(regM); 

    f = griddedInterpolant(HB, HA, regM,  'linear', 'none');
    
    grid.M = f(grid.Hb, grid.Ha); 
    grid.Ha(isnan(grid.M)) = NaN; 
    grid.Hb(isnan(grid.M)) = NaN; 
        
    Hcs = grid.Hc(~isnan(grid.M)); 
    Hus = grid.Hu(~isnan(grid.M)); 
    grid.maxHc = max(Hcs(:)); 
    grid.maxHu = max(Hus(:)); 
end