function XX = ForcFftSmoothing(X, SF, mode, f2)
    N1 = size(X,1);
    N2 = size(X,2);
    n1 = 2.^nextpow2(N1); 
    n2 = 2.^nextpow2(N2); 
    
    X(isnan(X)) = 0; 
    Y = fftshift(fft2(X, n1, n2));
    
    
    YY = Y; 
    maxd = sqrt(N1^2 + N2^2); 
    [xx, yy] = meshgrid(1-floor(n1/2):floor(n1/2), 1-floor(n2/2):floor(n2/2));
    d = sqrt(xx.^2 + yy.^2);
    if strcmpi(mode, 'gaussian')
        w = normpdf(d,0,SF*100); 
        w = w/max(w(:));
        YY = YY.*w; 
    elseif strcmpi(mode, 'cutoff')
        YY(d>(1-SF)*maxd) = 0; 
    end
    XX = ifft2(ifftshift(YY)); 
    
    XX = XX(1:size(X,1), 1:size(X,2));
    
    
    if nargin >= 4
        figure(f2);
        subplot(2,2,1);
        contourf(log(abs(Y))); 

        subplot(2,2,2);
        contourf(unwrap(angle(Y))); 


        subplot(2,2,3);
        contourf(log(abs(YY))); 

        subplot(2,2,4);
        contourf(unwrap(angle(YY))); 
    end
    
end