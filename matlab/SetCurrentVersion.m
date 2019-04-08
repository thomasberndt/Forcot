function SetCurrentVersion(version)
    try
        save(fullfile(tempdir, 'Forcot_version_v0.2.3-alpha.mat'), 'version'); 
    catch
    end
end