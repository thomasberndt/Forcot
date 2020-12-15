function q = ShapeAnisotropyInv1(N)
    if N == 0.5
        q = Inf; 
    elseif N == 0
        q = 1;
    else
        q = logspace(0, 2, 1000);
        NN = ShapeAnisotropy(q); 
        id = find(NN>=N, 1, 'first');
        q = q(id);
    end
end