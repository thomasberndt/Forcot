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
        forc = forc.rho; 
    elseif nargin < 6 
        limit = [];
    end
    
    if isempty(Hcplot)
        Hcplot = max(Hc(:));
    end
    if isempty(Huplot)
        Huplot = max(Hu(:));
    end
    
    forc = squeeze(forc);
    
    if isempty(limit)
        limit = EstimateForcPeak(forc, Hc, Hu, Hcplot, Huplot);
    end
    
    forc = forc / limit; 
    forccolors = ones(101,3); 
    forccolors(1:50,1) = linspace(0, 1, 50); 
    forccolors(1:50,2) = linspace(0, 1, 50); 
    forccolors(52:101,2) = linspace(1, 0, 50); 
    forccolors(52:101,3) = linspace(1, 0, 50); 
    vl = linspace(-1, 1, 20);  
    [~, h] = contourf(Hc*1000, Hu*1000, forc, vl, 'LineColor', 0.2*[1 1 1]);
    hold on
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
    caxis([-1 1]);
    lim = limit; 
    h = [h; mygridx; mygridy]; 
end