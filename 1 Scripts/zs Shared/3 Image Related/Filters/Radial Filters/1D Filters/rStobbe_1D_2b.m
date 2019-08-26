%------------------------------------------
%  Radial Stobbe Filter (1D)
%------------------------------------------

function F = rStobbe_1D_2b(r,p,n)

s2 = (1/p - n)/(1 - cos(pi*(1+p)));
s1 = s2 + n;

F0 = s1 + s2;

F = (s1 - s2*cos(pi*(1+r)))/F0;

if max(r) > 1
    abort;
end




