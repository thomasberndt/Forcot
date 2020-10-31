function [files, pathname, ext, n] = OpenForcDialog(pathname)
    if nargin == 1 && ~isempty(pathname)
        mask = fullfile(pathname, '*.*');
    else 
        mask = '*.*'; 
    end
    [filename, pathname] = uigetfile(mask);
    if filename == 0
        files = []; 
        pathname = [];
        ext = [];
        n = [];
    else
        [~, ~, ext] = fileparts(filename); 
        files = dir(sprintf('%s/*%s', pathname, ext)); 
        files = {files.name};
        n = find(strcmpi(files, filename));
    end
end