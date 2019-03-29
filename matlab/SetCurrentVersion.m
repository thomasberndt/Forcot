function SetCurrentVersion(version)
    try
        save(fullfile(tempdir, 'Forcot_version_v0.2.2-alpha.mat'), 'version'); 
    catch
    end
end