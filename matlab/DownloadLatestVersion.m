function filepath = DownloadLatestVersion(version)
    if nargin < 1
        version = CheckLatestVersion(); 
    end
    
    
    try
        url = ['https://thomasberndt.github.io/Forcot/' version]; 
        data = webread(url);
        
        filepath = fullfile(tempdir, version); 
        fileID = fopen(filepath, 'w');
        fwrite(fileID, data); 
        fclose(fileID); 
    catch
        filepath = []; 
    end
    
end