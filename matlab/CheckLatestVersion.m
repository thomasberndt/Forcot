function [version, link] = CheckLatestVersion(os)
    if nargin < 1
        os = [];
    end
    
    try
        mac = ''; 
        win = ''; 
        
        opt = weboptions(...
            'ContentType', 'json', ...
            'HeaderFields', {'Accept' 'application/vnd.github.v3+json'}, ...
            'Timeout', 5); 

        url = 'https://api.github.com/repos/thomasberndt/Forcot/releases/latest'; 
        S = webread(url, opt); 
        version = S.tag_name; 
        for n = 1:length(S.assets)
            if contains(S.assets(n).name, 'WebInstaller')
                win = S.assets(n).browser_download_url;
            elseif contains(S.assets(n).name, 'MacInstaller')
                mac = S.assets(n).browser_download_url;
            end
        end
                
        if isempty(os)
            if ismac
                link = mac; 
            elseif ispc
                link = win; 
            end
        elseif strcmpi(os, 'mac')
            link = mac; 
        else
            link = win; 
        end
        
    catch
        version = [];
    end
end