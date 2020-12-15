function q = ShapeAnisotropyInv(N)
    if length(N) == 1
        q = ShapeAnisotropyInv1(N);
    else
        q = zeros(size(N));
        for n = 1:length(N)
            q(n) = ShapeAnisotropyInv1(N(n));
        end
    end
end