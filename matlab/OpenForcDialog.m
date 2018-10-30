function [files, pathname, ext, n] = OpenForcDialog()
    [filename, pathname] = uigetfile('*.frc');
    [~, ~, ext] = fileparts(filename); 
    files = dir(sprintf('%s/*%s', pathname, ext)); 
    files = {files.name};
    n = find(strcmpi(files, filename)); 
end