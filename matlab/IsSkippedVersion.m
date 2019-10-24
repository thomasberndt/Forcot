function isSkipped = IsSkippedVersion(version)
    skippedVersions = GetSkippedVersions();
    isSkipped = false; 
    for n = 1:length(skippedVersions)
        if strcmpi(skippedVersions{n}, version)
            isSkipped = true; 
            break;
        end
    end    
end