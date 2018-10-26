function [M, rho, f3, tp, p, np] = SmoothForcFft(M, Ha, Hb, SF)
    dHa = abs(diff(Ha'));
    dHa = nanmean(dHa(:));
    dHb = abs(diff(Hb));
    dHb = nanmean(dHb(:));

    [X1, Y1] = size(M);
    M2 = NaN(2^nextpow2(max(X1,Y1)),2^nextpow2(max(X1,Y1)));
    M2(1:X1,end-Y1+1:end) = M; 

    M2 = FillNaNs(M2);

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

    if SF == 0 
        filter = 1;
    else
        filter = sqrt(2*pi)*SF* exp(-2*pi^2*SF^2.*((KX*dHa).^2+(KY*dHb).^2)); 
    end
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
    rho = M((end/2+1):(end/2+X1),(end/2-Y1+1):end/2);
end