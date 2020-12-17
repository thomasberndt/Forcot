function [V, HK] = GetV(rho_B, rho, t1, t2, Ms, Hc, T, tau0)
    k = 1.38e-23;
    mu0 = pi*4e-7; 
    
    t = t1;
    Dt = t2/t1;
    
    V = 2*k*T*log(t/tau0).^2*Dt ./ (mu0.*Ms.*Hc.^2) .* rho_B./rho .* ...
        (1 - (Dt*log(t/tau0).*rho_B ./ (Hc.*rho)));
    HK = Dt^3*log(t/tau0) ./ (mu0^2*Ms.^2.*Hc.^4) .* (rho_B./rho).^3 .* ...
        (1 - (Dt*log(t/tau0).*rho_B ./ (Hc.*rho)));
end