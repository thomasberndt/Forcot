function N = ShapeAnisotropy(q)
    p = 1; 
    Fp0 = ShapeAnisotropyF(p,0);
    Fpq = ShapeAnisotropyF(p,q);
    g = (Fp0 - Fpq)./(p.*q);
    N = 2*pi - 6*g;
    N = N/(4*pi);
end