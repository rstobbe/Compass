%------------------------------------------
%  Radial Kaiser Filter (1D)
%------------------------------------------

function [F F0] = rKaiser_1D_N_OS(R,p,beta)

F = @(r) (1/p)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2));
F0 = F(0);

F = zeros(R,1,'single');
for x = 1:R
    r = (x-1)/(R-1);
    F(x) = ((1/p)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)))/F0;
    if r > 1
        F(x) = 0;
    end
end



