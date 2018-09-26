function lab = FourierToLabColors(F)
    [lF, pF] = ScaleFourierColors(F);     
    lab = LabColors(1-lF, pF);
end