function filepath = DownloadLatestVersion(link)
    if nargin < 1
        [~, link] = CheckLatestVersion();
    end
    
    
    try
        [~, filename, ext] = fileparts(link);
        filepath = fullfile(tempdir, [filename ext]);         
        opt = weboptions('Timeout', 300); 
        filepath = websave(filepath, link, opt);
    catch
        filepath = []; 
    end
    
end