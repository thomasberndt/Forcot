function [version, versions] = CheckLatestVersion()
    
    try
        if ismac
            url = 'https://thomasberndt.github.io/Forcot/versions_mac.txt'; 
        elseif ispc
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