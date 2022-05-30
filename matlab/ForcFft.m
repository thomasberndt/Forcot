function [f, KX, KY, MM, dHa, dHb] = ForcFft(M, Ha, Hb)
    dHa = abs(diff(Ha'));
    dHa = mean(dHa(:), 'omitnan');
    dHb = abs(diff(Hb));
    dHb = mean(dHb(:), 'omitnan');

    M2 = ForcGridToFftGrid(M);
    MM = [flipud(M2), rot90(M2, 2); M2, fliplr(M2)]; 

    f = fft2(MM);
    [X, Y] = size(f); 
    kx = (-X/2):(X/2-1);
    ky = (-Y/2):(Y/2-1); 
    kx = kx/(dHa*X/2); 
    ky = ky/(dHb*Y/2); 
    [KX, KY] = meshgrid(fftshift(kx), fftshift(ky)); 
    KX = KX';
    KY = KY';
end