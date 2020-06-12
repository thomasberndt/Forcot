function installing = InstallLatestVersion(filepath)
    try
        installing = 0; 
        if exist(filepath, 'file')
            installing = 1;
            try
                if ispc
                    winopen(filepath);
                else
                    msgbox(sprintf('File %s was downloaded, but needs to be installed manually on a Mac', filepath));
                end
            catch ME
                msgbox(sprintf('File %s was downloaded, but needs to be installed manually due to the following error: %s', ...
                    filepath, ME.message));
            end
        else
            msgbox('File could not be downloaded. Please download the new version manually from https://github.com/thomasberndt/Forcot/releases/latest');
        end
    catch
        msgbox('File could not be downloaded. Please download the new version manually from https://github.com/thomasberndt/Forcot/releases/latest');
    end
end