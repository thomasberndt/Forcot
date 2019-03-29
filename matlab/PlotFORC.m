function [lim, h, ax] = PlotFORC(forc, Hc, Hu, Hcplot, Huplot, limit, PlotFirstPointArtifact, ColorScheme)
% Plots the FORC. 
% forc - the FORC distribution (matrix)
% Hc, Hu - the grid (regular or irregular) of the FORC in Tesla. 
% Hcplot, Huplot - the axis limits in Tesla: The Forc is ploted from 0 to
% Hcplot and from -Huplot to +Huplot. 
% limit - Optional. Sets a value used for normalization. If not given, the
% FORC is normalized by its peak value. 
% PlotFirstPointArtifact - Optional. If 1, plots first point artifact, if 0 plots
% first point artifact white. Default is 1.
% ColorScheme - Optional. Either 'redyellowblue' (default) or 'redblue'.
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
        if isfield(forc, 'PlotFirstPointArtifact')
            PlotFirstPointArtifact = forc.PlotFirstPointArtifact; 
        else 
            PlotFirstPointArtifact = 1;
        end
        if isfield(forc, 'ColorScheme')
            ColorScheme = forc.ColorScheme;
        else
            ColorScheme = 'redyellowblue';
        end
        SF = forc.SF; 
        forc = forc.rho; 
    else
        if nargin < 6
            limit = [];
        end 
        if nargin < 7
            PlotFirstPointArtifact = 1; 
        end
        if nargin < 8
            ColorScheme = 'redyellowblue';
        end
    end
    
    if nargin == 3 || isempty(Hcplot)
        Hcplot = max(Hc(:));
    end
    if nargin == 3 || isempty(Huplot)
        Huplot = max(Hu(:));
    end
    minHc = 0.003; 
    
    forc = squeeze(forc);
    if ~isempty(SF)
        minHc = abs(Hc(2,2)-Hc(1,1))*SF*1.5; 
%         if ~PlotFirstPointArtifact
%             forc(Hc <= minHc) = NaN;
%         end
    end
    
    if isempty(limit)
        limit = EstimateForcPeak(forc, Hc, Hu, Hcplot, Huplot, minHc);
    end
    
    if abs(limit) < 100e-6
        limit = limit / 1e-6; 
        forc = forc / 1e-6; 
        forcunits = '\mu';
    elseif abs(limit) < 100e-3
        limit = limit / 1e-3; 
        forc = forc / 1e-3; 
        forcunits = 'm';
    else
        forcunits = '';
    end
    
%     forc = forc / limit;
    forccolors = GetForcColors(ColorScheme);
    ls = logspace(-3, 0, 30); 
    vl = limit * [-ls(end:-1:1) ls(1:end)]; 
%     [~, h] = contourf(Hc*1000, Hu*1000, forc, vl, 'EdgeColor', 0.2*[1 1 1]);
    res = 1;
    if min(size(Hc)) > 200
        res = 2;
    end
    if min(size(Hc)) > 400
        res = 3;
    end
    h = pcolor(Hc(1:res:end,1:res:end)*1000, ...
               Hu(1:res:end,1:res:end)*1000, ...
               forc(1:res:end,1:res:end)); 
    set(h, 'EdgeColor', 'none');
    shading interp
    hold on
    caxis(limit * [-1 1]);
    
    ls = [10^-1.5 logspace(-1, 0, 10)]; 
    vl = limit * [-ls(end:-1:1) ls(1:end)]; 
    [~, h] = contour(Hc*1000, Hu*1000, forc, vl, 'EdgeColor', 0*[1 1 1]);
    shading interp
    axis([0 Hcplot -Huplot Huplot]*1000);
    
    if ~isempty(SF) && ~PlotFirstPointArtifact
        patch([0 minHc minHc 0]*1200 , ...
            [-Huplot -Huplot Huplot Huplot]*1000, ...
            [1 1 1], ...
            'EdgeColor', [1 1 1]); 
    end
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
                'FontSize', 18, ...
                'HorizontalAlignment', 'right', ...
                'VerticalAlignment', 'top'); 
    end
    h = colorbar;
    set(get(h,'title'),'string',sprintf('%sAm^2/T^2', forcunits));
end