
files = dir('D:\Dropbox\Documents\Studies\Semester 14 Beijing Fall\TAFORC_priv\data\ta_sediments\PETM\Grain sizes\*.csv');

figure;
Nedge = 15; 

for n = 1:length(files) 
    file = fullfile(files(n).folder, files(n).name);
    [~, name, ~] = fileparts(files(n).name); 
    c = readmatrix(file);
    L = c(:,1);
    W = c(:,2);
    D = (L+W) / 2; 
    V = L.*W.*D; 
    v = V.^(1/3);
    a = W./L; 
%     plot(a, L, 'o', 'DisplayName', name);

    subplot(2,1,1); 
    edges = linspace(0, 100, Nedge); 
    edges(end+1) = Inf; 
    h = histcounts(L, edges); 
    edges(end) = []; 
    plot(edges, h/max(h), LineWidth=2, DisplayName=name);
    legend("Location", "best");
    hold on 

    subplot(2,1,2); 
    edges = linspace(0.6, 1, Nedge);
    edges(end+1) = Inf; 
    h = histcounts(a, edges); 
    edges(end) = []; 
    plot(edges, h/max(h), LineWidth=2, DisplayName=name);
    legend("Location", "best");
    hold on 
end