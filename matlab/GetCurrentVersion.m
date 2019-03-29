function version = GetCurrentVersion()

    thisversion = '';
    if ismac 
        thisversion = 'Forcot_MacInstaller_v0.2.2-alpha.exe';
    elseif ispc
        thisversion = 'Forcot_WebInstaller_v0.2.2-alpha.exe';
    end

    try
        stufftoload = load(fullfile(tempdir, 'Forcot_version_v0.2.2-alpha.mat')); 
        version = stufftoload.version; 
    catch
        version = thisversion; 
    end

end