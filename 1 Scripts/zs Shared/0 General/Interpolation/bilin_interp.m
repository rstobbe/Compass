%==================================================
% Bilinear Interpolation
%==================================================

function Val = bilin_interp(K,x,y)


x0 = floor(x);
x1 = ceil(x);
y0 = floor(y);
y1 = ceil(y);

K1 = (K(x1,y0) - K(x0,y0)).*(x-x0) + K(x0,y0);
K2 = (K(x1,y1) - K(x0,y1)).*(x-x0) + K(x0,y1);

Val = (K2 - K1).*(y-y0) + K1;


