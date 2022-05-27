function T = GetTemperatureFromFilename(filename)
    taforc_temperature = regexp(filename, '[^a-zA-Z0-9]([0-9]+)K\.t[sa]forc', 'tokens');
    if ~isempty(taforc_temperature)
        T = str2double(taforc_temperature{1}{1});
    else
        T = 293;
    end
end