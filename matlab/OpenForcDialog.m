function [files, pathname, ext, n] = OpenForcDialog(pathname)
    if nargin == 1 && ~isempty(pathname)
        mask = fullfile(pathname, '*.frc');
    else 
        mask = '*.frc'; 
    end
    [filename, pathname] = uigetfile(mask);
    [~, ~, ext] = fileparts(filename); 
    files = dir(sprintf('%s/*%s', pathname, ext)); 
    files = {files.name};
    n = find(strcmpi(files, filename)); 
end