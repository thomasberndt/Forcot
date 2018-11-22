function forccolors = GetForcColors(theme)

    if nargin < 1
        theme = 'redblue';
    end

    if strcmpi(theme, 'redblue')
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
    elseif strcmpi(theme, 'roberts')
        forccolors = ones(1001,3); 
        m = -1.5; 
        forccolors(1:500,1) = logspace(m, 0, 500); 
        forccolors(1:500,2) = logspace(m, 0, 500); 
        forccolors(502:701,3) = logspace(0, -0.5, 200); 
        forccolors(702:1001,2) = logspace(0, -1, 300); 
        forccolors(702:1001,3) = 0; 
    else
        forccolors = theme; 
    end
end