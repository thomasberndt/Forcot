
function F = ShapeAnisotropyF(p,q)
    F1 = (p.^2-q.^2).*asinh(1./sqrt(p.^2+q.^2));
    F2 = p.*(1-q.^2).*asinh(p./sqrt(1+q.^2));
    if q == 0
        F3a = 0;
        F3b = 0;
    else
        F3a = p.*q.^2.*asinh(p./q);
        F3b = q.^2.*asinh(1./q);
    end
    F4 = 2*p.*q.*atan((q./p).*sqrt(1+p.^2+q.^2));
    F5a = -pi*p.*q;
    F5b = -1.0/3.0.*(1+p.^2-2*q.^2).*sqrt(1+p.^2+q.^2);
    F6 = 1.0/3.0.*(1-2*q.^2).*sqrt(1+q.^2);
    F7a = 1.0/3.0.*(p.^2-2.*q.^2).*sqrt(p.^2+q.^2);
    F7b = 2.0/3.0.*q.^3;
    F = F1 + F2 + F3a + F3b + F4 + F5a + F5b + F6 + F7a + F7b;
end