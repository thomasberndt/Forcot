function princeton = AverageOfRepeatedForcs(rep_princetons)
    princeton = rep_princetons{1}; 
    princeton.grid.M = zeros(size(princeton.grid.M));
    for n = 1:length(rep_princetons)
        princeton.grid.M = princeton.grid.M + rep_princetons{n}.grid.M;
    end
    princeton.grid.M = princeton.grid.M / length(rep_princetons);
end