function version = GetCurrentVersion()

    thisversion = '';
    if ismac 
        thisversion = 'Forcot_MacInstaller_v1.0.0.exe';
    elseif ispc
        thisversion = 'Forcot_WebInstaller_v1.0.0.exe';
    end

    try
        stufftoload = load(fullfile(tempdir, 'Forcot_version_v1.0.0.mat')); 
        version = stufftoload.version; 
    catch
        version = thisversion; 
    end

end