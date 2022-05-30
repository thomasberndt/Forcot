function pc = ForcFftPca(files)
    [forcs, Ha, Hb] = LoadForcsForForcPca(files);
%     save forcs
%     save Ha
%     save Hb
%     load forcs.mat
%     load Ha.mat
%     load Hb.mat
    [X, Y, ~] = size(forcs);
    g = [];
    for n = 1:size(forcs,3)
        g(:,:,n) = ForcFft(forcs(:,:,n), Ha, Hb);
    end
    sz = size(g);
    f = reshape(g, sz(1)*sz(2), sz(3));
    f = f'; 
    [coeff,score,latent,tsquared,explained,mu] = pca(f);
    pc_fft = reshape(coeff, sz(1), sz(2), []);
    
    N = size(pc_fft, 3);
    pc = [];
    for n = 1:N
        pc_inv = ifft2(pc_fft(:,:,n));
        pc(:,:,n) = pc_inv((end/2+1):(end/2+X),(end/2-Y+1):end/2);
    end
end