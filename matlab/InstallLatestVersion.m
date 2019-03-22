function installing = InstallLatestVersion(filepath)
    try
        installing = 0; 
        if exist(filepath, 'file')
            installing = 1;
            open(filepath);
        end
    catch 
    end
end