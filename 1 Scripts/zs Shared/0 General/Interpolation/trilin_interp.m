%==================================================
% Trilinear Interpolation
%==================================================

function Val = trilin_interp(K,x,y,z)


x0 = floor(x);
x1 = ceil(x);
y0 = floor(y);
y1 = ceil(y);
z0 = floor(z);
z1 = ceil(z);


K1 = (K(x1,y0,z0) - K(x0,y0,z0))*(x-x0) + K(x0,y0,z0);
K2 = (K(x1,y1,z0) - K(x0,y1,z0))*(x-x0) + K(x0,y1,z0);
K3 = (K(x1,y0,z1) - K(x0,y0,z1))*(x-x0) + K(x0,y0,z1);
K4 = (K(x1,y1,z1) - K(x0,y1,z1))*(x-x0) + K(x0,y1,z1);

K5 = (K2 - K1)*(y-y0) + K1;
K6 = (K4 - K3)*(y-y0) + K3;

Val = (K6 - K5)*(z-z0) + K5;

%test = 0;

