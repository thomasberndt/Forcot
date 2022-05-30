function [pc, rec_forc] = ForcFftPhasePca(files)
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
    f_abs = abs(f);
    max_amplitude = max(f_abs(:)); 
    f_abs = f_abs / max_amplitude * pi; 
    f_phase = angle(f);
    f2 = [f_abs f_phase];

    [coeff,score,latent,tsquared,explained,mu] = pca(f2);

    coeff_abs = coeff(1:end/2,:) / pi * max_amplitude;
    coeff_phase = coeff(end/2+1:end,:);
    pc_abs = reshape(coeff_abs, sz(1), sz(2), []);
    pc_phase = reshape(coeff_phase, sz(1), sz(2), []);
    pc_fft = abs(pc_abs).*exp(1i*pc_phase);

    N = size(pc_fft, 3);
    pc = [];
    for n = 1:N
        pc_inv = ifft2(pc_fft(:,:,n));
        pc(:,:,n) = pc_inv((end/2+1):(end/2+X),(end/2-Y+1):end/2);
    end

    disp(explained);
    
    figure
    imagesc((abs(score)));
    colormap gray
    colorbar

    score_approx = score; 
    score_approx(:,5:end) = 0; 
    reconstructed = (score_approx * coeff' + repmat(mu, size(forcs,3), 1))';

    coeff_abs = reconstructed(1:end/2,:) / pi * max_amplitude;
    coeff_phase = reconstructed(end/2+1:end,:);
    pc_abs = reshape(coeff_abs, sz(1), sz(2), []);
    pc_phase = reshape(coeff_phase, sz(1), sz(2), []);
    pc_fft = abs(pc_abs).*exp(1i*pc_phase);

    rec_forc = [];
    for n = 1:size(forcs,3)
        pc_inv = ifft2(pc_fft(:,:,n));
        rec_forc(:,:,n) = real(pc_inv((end/2+1):(end/2+X),(end/2-Y+1):end/2));
    end

end