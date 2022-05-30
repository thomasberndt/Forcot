function [M2, X, Y] = ForcGridToFftGrid(M)
    [X, Y] = size(M);
    M2 = NaN(2^nextpow2(max(X,Y)),2^nextpow2(max(X,Y)));
    M2(1:X,end-Y+1:end) = M; 

    M2 = FillNaNs(M2, 'extrapolate');
end
