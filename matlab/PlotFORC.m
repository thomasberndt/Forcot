function [lim, h, ax] = PlotFORC(forc, Hc, Hu, Hcplot, Huplot, limit)
% Plots the FORC. 
% forc - the FORC distribution (matrix)
% Hc, Hu - the grid (regular or irregular) of the FORC in Tesla. 
% Hcplot, Huplot - the axis limits in Tesla: The Forc is ploted from 0 to
% Hcplot and from -Huplot to +Huplot. 
% limit - Optional. Sets a value used for normalization. If not given, the
% FORC is normalized by its peak value. 
%
% OUTPUT: 
% lim - Returns the value used for normalization. 
% h - handle to the plot
% ax - handle to the axes
% 
% All these parameters can also be wrapped into a struct and passed as one
% single argument.
    
    SF = []; 
    if nargin == 1
        Hc = forc.Hc; 
        Hu = forc.Hu;  
        Hcplot = forc.maxHc; 
        Huplot = forc.maxHu;
        if isfield(forc, 'limit')
            limit = forc.limit; 
        else 
            limit = [];
        end
        SF = forc.SF; 
        forc = forc.rho; 
    elseif nargin < 6 
        limit = [];
    end
    
    if nargin == 3 || isempty(Hcplot)
        Hcplot = max(Hc(:));
    end
    if nargin == 3 || isempty(Huplot)
        Huplot = max(Hu(:));
    end
    
    forc = squeeze(forc);
    
    if isempty(limit)
        limit = EstimateForcPeak(forc, Hc, Hu, Hcplot, Huplot);
    end
    
%     forc = forc / limit;
%     forccolors = LabColors(0, linspace(0, 1, 101));
    forccolors = ones(1001,3); 
    w = 3;
    m = -1.5; 
%     forccolors(1:50,1) = linspace(0, 1, 50).^w; 
%     forccolors(1:50,2) = linspace(0, 1, 50).^w; 
%     forccolors(52:101,2) = linspace(1, 0, 50).^w; 
%     forccolors(52:101,3) = linspace(1, 0, 50).^w; 
    
    forccolors(1:500,1) = logspace(m, 0, 500); 
    forccolors(1:500,2) = logspace(m, 0, 500); 
    forccolors(502:1001,2) = logspace(0, m, 500); 
    forccolors(502:1001,3) = logspace(0, m, 500); 
    ls = logspace(-3, 0, 30); 
    vl = limit * [-ls(end:-1:1) ls(1:end)]; 
%     [~, h] = contourf(Hc*1000, Hu*1000, forc, vl, 'EdgeColor', 0.2*[1 1 1]);
    h = pcolor(Hc*1000, Hu*1000, forc); 
    set(h, 'EdgeColor', 'none');
    shading interp
    hold on
    
    ls = [10^-1.5 logspace(-1, 0, 10)]; 
    vl = limit * [-ls(end:-1:1) ls(1:end)]; 
    [~, h] = contour(Hc*1000, Hu*1000, forc, vl, 'EdgeColor', 0*[1 1 1]);
    shading interp
    axis([0 Hcplot -Huplot Huplot]*1000);
    ax = gca; 
    x_gridx = repmat(ax.XTick, 2, 1); 
    x_gridy = repmat([-Huplot; Huplot]*1000, 1, length(ax.XTick));
    y_gridy = repmat(ax.YTick, 2, 1); 
    y_gridx = repmat([0; Hcplot]*1000, 1, length(ax.YTick));
    mygridx = plot(x_gridx, x_gridy, 'k-'); 
    gridalpha = 0.25;
    for n = 1:numel(mygridx)
        if ax.XTick(n) ~= 0
            mygridx(n).Color(4) = gridalpha;
        end
    end
    mygridy = plot(y_gridx, y_gridy, 'k-'); 
    for n = 1:numel(mygridy)
        mygridy(n).Color(4) = gridalpha;
    end
    hold off
    xlabel('H_c [mT]'); 
    ylabel('H_u [mT]'); 
    colormap(forccolors);
    caxis([-1 1]*limit)
%     caxis([-1 1]);
    lim = limit; 
    h = [h; mygridx; mygridy]; 
    if ~isempty(SF)
        text(0.99, 0.99, sprintf('SF=%g', SF), ...
                'Units', 'normalized', ...
                'BackgroundColor', 'white', ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'right', ...
                'VerticalAlignment', 'top'); 
    end
    colorbar
end