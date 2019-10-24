function skippedVersions = GetSkippedVersions()
    try
        stufftoload = load(fullfile(tempdir, 'Forcot_versions.mat')); 
        skippedVersions = stufftoload.skippedVersions;
    catch
        skippedVersions = {}; 
    end
end