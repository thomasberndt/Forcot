function version = GetCurrentVersion()

    thisversion = 'Forcot_WebInstaller_v0.1.4-alpha.exe';

    try
        stufftoload = load(fullfile(tempdir, 'Forcot_version.mat')); 
        version = stufftoload.version; 
    catch
        version = thisversion; 
    end

end