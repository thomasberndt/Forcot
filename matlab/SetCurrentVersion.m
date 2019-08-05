function SetCurrentVersion(version)
    try
        save(fullfile(tempdir, 'Forcot_version_v1.0.0.mat'), 'version'); 
    catch
    end
end