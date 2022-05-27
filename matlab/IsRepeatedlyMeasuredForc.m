function repeated_measured = IsRepeatedlyMeasuredForc(filename)
    [~, ~, ext] = fileparts(filename); 
    repeated_measured = ~isnan(str2double(ext));
end