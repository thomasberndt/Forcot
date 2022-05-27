function [files, pathname, ext, n, repeated] = OpenForcDialog(pathname)
    if nargin == 1 && ~isempty(pathname)
        mask = fullfile(pathname, '*.*');
    else 
        mask = '*.*'; 
    end
    repeated = false; 
    [filename, pathname] = uigetfile(mask);
    if filename == 0
        files = []; 
        pathname = [];
        ext = [];
        n = [];
    else
        [~, name, ext] = fileparts(filename); 
        if IsRepeatedlyMeasuredForc(filename)
            answer = questdlg('The file seems to be parted of a series of repeatedly measured FORC diagrams. Do you want to view the averaged diagrams?', ...
	            'Repeatedly measured', 'Yes, average diagrams', 'No, individual diagrams', 'Yes, average diagrams');
            if strcmpi(answer, 'Yes, average diagrams')
                [~, name, ext2] = fileparts(name); 
                ext = strcat(ext2, '.000');
                repeated = true;
                files = dir(sprintf('%s/*%s', pathname, ext)); 
                files = {files.name};
                n = find(strcmpi(files, strcat(name, ext)));
            else
                repeated = false;
                files1 = dir(sprintf('%s/*.???', pathname)); 
                files1 = {files1.name};
                files = {};
                for n = 1:length(files1)
                    if IsRepeatedlyMeasuredForc(files1{n})
                        files{end+1} = files1{n};
                    end
                end
                n = find(strcmpi(files, strcat(name, ext)));
            end
        else
            files = dir(sprintf('%s/*%s', pathname, ext)); 
            files = {files.name};
            n = find(strcmpi(files, filename));
        end
    end
end