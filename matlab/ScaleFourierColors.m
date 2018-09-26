function [lF, pF] = ScaleFourierColors(F)
    lF = log10(abs(F)); 
    pF = unwrap(angle(F)); 
    lF = lF - min(lF(abs(lF)~=Inf)); 
    lF = lF / max(lF(abs(lF)~=Inf));
    pF = pF - min(pF(abs(lF)~=Inf)); 
    pF = pF / max(pF(abs(lF)~=Inf)); 
    lF(lF<0) = 0; 
    pF(pF<0) = 0; 
end