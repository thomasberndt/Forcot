function repeated_measured = GetRepeatedlyMeasuredForc(filename)

    if IsRepeatedlyMeasuredForc(filename)
        repeated_measured = {};
        [pathname, file, ext] = fileparts(filename); 
    
        for ext_n = 0:99
            file_n = sprintf('%s/%s.%03.f', pathname, file, ext_n); 
            if exist(file_n, 'file')
                repeated_measured{end+1} = file_n;
            else
                break;
            end
        end
    else
        repeated_measured = {filename}; 
    end
end