function SetCurrentVersion(version)
    try
        save(fullfile(tempdir, 'Forcot_version.mat'), 'version'); 
    catch
    end
end