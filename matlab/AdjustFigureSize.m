function AdjustFigureSize(fig, Hcplot, Huplot)
    pos = get(fig, 'OuterPosition');
    myunits = get(fig, 'Units');
    set(gcf, 'Units', 'Pixels');
    myheight = 0.96*pos(3)/Hcplot*2*Huplot + 100;
    myheight = min(myheight, pos(3));
    set(fig, 'OuterPosition', [pos(1) pos(2)+pos(4)-myheight pos(3) myheight]);
    set(fig, 'Units', myunits);
end