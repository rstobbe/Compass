%------------------------------------------
%  Radial Kaiser Filter (1D)
%------------------------------------------

function [F F0] = rKaiser_1D_N(R,p,beta)

F = @(r) (1/p)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2));
F0 = F(0);

F = zeros(R,1,'single');
for x = 1:R
    r = abs((x-(R+1)/2)/((R-1)/2));
    F(x) = ((1/p)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)))/F0;
    if r > 1
        F(x) = 0;
    end
end



