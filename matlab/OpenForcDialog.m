function [files, pathname, n] = OpenForcDialog()
    [filename, pathname] = uigetfile('*.frc');
    files = dir(sprintf('%s/*.frc', pathname)); 
    files = {files.name};
    n = find(strcmpi(files, filename)); 
end