function [M, rho, f3, KX, KY] = SmoothNoiseForcFft(M, Ha, Hb, SF)
    dHa = abs(diff(Ha'));
    dHa = mean(dHa(:), 'omitnan');
    dHb = abs(diff(Hb));
    dHb = mean(dHb(:), 'omitnan');

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
    
    f2 = (2i*pi)^2.*KX.*KY.*f; 
    
    
    filter = exp(-2*pi^2*SF^2.*((KX*dHa).^2+(KY*dHb).^2)); 
%     filter = sech(pi^2*SF^2*((KX*dHa).^2+(KY*dHb).^2));
    
    r = linspace(0, 1, 100); 
    p = zeros(length(r)-1,1);
    pfil = zeros(length(r)-1,1); 
    for n = 1:length(r)-1
        d = sqrt((KX*dHa).^2+(KY*dHb).^2); 
        idx = logical(r(n) <= d & d < r(n+1)); 
        p(n) = log10(mean(abs(f2(idx)).^2)); 
    end
    r(end) = []; 
    
    
    SF = 1; 
    
    
    idx = logical(r>0.5);
    pf = polyfit(r(idx), p(idx)', 1); 
    
    
    plot(r, p, 'o-', r, polyval(pf, r), '-'); 
    
    d = sqrt((KX*dHa).^2+(KY*dHb).^2);
    pp = pf(2) + pf(1)*d;
    filter = (10.^pp).^-2; 
    f3 = filter.*f2;
    
    for n = 1:length(r)-1
        d = sqrt((KX*dHa).^2+(KY*dHb).^2); 
        idx = logical(r(n) <= d & d < r(n+1)); 
        pfil(n) = log10(mean(abs(f3(idx)).^2)); 
    end
    
%     plot(r, 10.^p, 'o-', r, 10.^polyval(pf, r), '-', r, 10.^pfil, 'd-'); 
    
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