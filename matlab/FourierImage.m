function IM = FourierImage(F)
    tform = projective2d([-1 1 0; 1 1 0; 0 0 1]); 
    [lF, pF] = ScaleFourierColors(F); 
    
    lIM = imwarp(lF, tform);
    pIM = imwarp(pF, tform);
    
    X = size(lIM, 1);
    Y = size(lIM, 2);
    
    lIM = lIM(floor(X*.25):ceil(X*.75), floor(Y*0.5):ceil(Y*0.75)); 
    pIM = pIM(floor(X*.25):ceil(X*.75), floor(Y*0.5):ceil(Y*0.75)); 
    
    lIM = lIM / max(lIM(:));
    pIM = pIM - min(pIM(lIM>0.1)); 
    pIM = pIM / max(pIM(lIM>0.1)); 
    pIM(pIM<0) = 0;
    pIM(pIM>1) = 1; 
    
    IM = LabColors(1-lIM, pIM);
end