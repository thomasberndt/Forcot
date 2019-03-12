
x = linspace(0,3);

SFs = 0:0.5:3; 
clf

for n = 1:length(SFs)
    SF = SFs(n);
    tri = (1-x.^3/SF^3).^3; 
    gaus = exp(-x.^2./(2*SF.^2));
    
    tri(x>SF) = 0;
    
    plot(x, tri, 'k-', x, gaus, 'b-');
    hold on
end