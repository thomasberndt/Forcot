function [version, versions] = CheckLatestVersion(os)
    if nargin < 1
        os = [];
    end
    
    try
        if isempty(os)
            if ismac
                url = 'https://thomasberndt.github.io/Forcot/versions_mac.txt'; 
            elseif ispc
                url = 'https://thomasberndt.github.io/Forcot/versions_win.txt'; 
            end
        elseif strcmpi(os, 'mac')
            url = 'https://thomasberndt.github.io/Forcot/versions_mac.txt'; 
        else
            url = 'https://thomasberndt.github.io/Forcot/versions_win.txt'; 
        end
        data = webread(url);
        versions = split(data); 
        version = versions{end}; 
    catch
        versions = {}; 
        version = [];
    end
end