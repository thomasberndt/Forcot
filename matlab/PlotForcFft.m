function PlotForcFft(f, dHa, dHb)
    F = fftshift(f); 
    lab = FourierToLabColors(F);
    image(1/dHa*[-1 1], 1/dHb*[-1 1], lab);
    xlabel('Wave number H_a');
    ylabel('Wave number H_b');
end