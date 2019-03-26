function version = GetCurrentVersion()

    thisversion = '';
    if ismac 
        thisversion = 'Forcot_MacInstaller_v0.1.6-alpha.exe';
    elseif ispc
        thisversion = 'Forcot_WebInstaller_v0.1.6-alpha.exe';
    end

    try
        stufftoload = load(fullfile(tempdir, 'Forcot_version.mat')); 
        version = stufftoload.version; 
    catch
        version = thisversion; 
    end

end