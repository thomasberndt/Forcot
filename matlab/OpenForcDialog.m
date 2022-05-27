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
%         if IsRepeatedlyMeasuredForc(filename)
%             % numerical extension means that multiple 
%             % repeated measurements where done
%             
%             files = {};
%             n = 0;
%             ext = '000'; 
%             for ext_n = 0:99
%                 files_n = dir(sprintf('%s/*%03.f', pathname, ext_n)); 
%                 files_n = {files_n.name};
%                 files = cat(2, files, files_n);
%             end
%         else
            [~, name, ext] = fileparts(filename); 
            if IsRepeatedlyMeasuredForc(filename)
                [~, ~, ext2] = fileparts(name); 
                ext = strcat(ext2, ext);
            end
            files = dir(sprintf('%s/*%s', pathname, ext)); 
            files = {files.name};
%         end
        n = find(strcmpi(files, filename));
    end
end