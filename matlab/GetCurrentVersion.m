function version = GetCurrentVersion()

    thisversion = '';
    if ismac 
        thisversion = 'Forcot_MacInstaller_v0.1.7-alpha.exe';
    elseif ispc
        thisversion = 'Forcot_WebInstaller_v0.1.7-alpha.exe';
    end

    try
        stufftoload = load(fullfile(tempdir, 'Forcot_version_v0.1.7-alpha.mat')); 
        version = stufftoload.version; 
    catch
        version = thisversion; 
    end

end