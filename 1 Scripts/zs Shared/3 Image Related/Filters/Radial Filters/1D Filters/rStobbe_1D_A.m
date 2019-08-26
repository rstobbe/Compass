%------------------------------------------
%  Radial Stobbe Filter (1D)
%------------------------------------------

function [F F0] = rStobbe_1D_A(Ksz,p,n)

s2 = (1/p - n)/(1 - cos(pi*(1+p)));
s1 = s2 + n;

F0 = s1 + s2;

F = zeros(1,Ksz,'single');
for x = 1:Ksz
    r = (x-(Ksz+1)/2)/((Ksz-1)/2);
    F(x) = (s1 - s2*cos(pi*(1+r)));
    if r > 1
        F(x) = 0;
    end
end





