function [M, rho, f3] = SmoothForcFft(f, SF, sz)
    [X, Y] = size(f); 
    kx = (-X/2):(X/2-1);
    ky = (-Y/2):(Y/2-1); 
    [KX, KY] = meshgrid(fftshift(kx), fftshift(ky)); 
    KX = KX';
    KY = KY';

    filter = exp(-SF.*(KX.^2+KY.^2)); 
    f2 = (2i*pi)^2.*KX.*KY.*f; 
    f3 = filter.*f2;
    fn = (1-filter).*f2; 
    power = abs(f3).^2;
    npower = abs(fn).^2; 
    totalpower = abs(f2).^2; 
    tp = sum(totalpower(:));
    p = sum(power(:)); 
    np = sum(npower(:)); 

    M = ifft2(f3); 
    X1 = sz(1); 
    Y1 = sz(2);
    rho = M((end/2+1):(end/2+X1),(end/2-Y1+1):end/2);
end