function pc = ForcPca(files)
    forcs = LoadForcsForForcPca(files);
%     save forcs
%     load forcs.mat
    sz = size(forcs);
    f = reshape(forcs, sz(1)*sz(2), sz(3));
    f = f'; 
    nanmask = isnan(f(:,:,1));
    f(nanmask) = 0; 
    [coeff,score,latent,tsquared,explained,mu] = pca(f);
    pc = reshape(coeff, sz(1), sz(2), []);

end