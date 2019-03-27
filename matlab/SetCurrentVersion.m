function SetCurrentVersion(version)
    try
        save(fullfile(tempdir, 'Forcot_version_v0.1.7-alpha.mat'), 'version'); 
    catch
    end
end