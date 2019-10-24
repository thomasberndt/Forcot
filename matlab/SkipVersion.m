function SkipVersion(version)
    try
        skippedVersions = GetSkippedVersions(); 
        skippedVersions{end+1} = version; 
        save(fullfile(tempdir, 'Forcot_versions.mat'), 'skippedVersions'); 
    catch
    end
end