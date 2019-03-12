function InstallLatestVersion(filepath)
    try
        if exist(filepath, 'file')
            [status,cmdout] = system([filepath ' &']);
        end
    catch 
    end
end