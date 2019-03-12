function [d2f, x2, y2] = MixedDerivative(f, x, y)
% Calculates the mixed second derivative of f.
% f - a 2-dimensional matrix
% x, y - cooredinates of f. Two 2-dimensional matrices, e.g. created with
% meshgrid.
% OUTPUT: d2f - mixed second derivative of f (2-dimensional matrix
%         x2, y2 - 2-dimensional matrices with the coordinates. Same as x,
%         y, but with the same size as d2f. 
    d2f = diff(diff(f, 1, 1), 1, 2)./diff(x(1:end-1,:), 1, 2)./diff(y(:,1:end-1), 1, 1); 
    x2 = x(1:end-1,1:end-1);
    y2 = y(1:end-1,1:end-1); 
end