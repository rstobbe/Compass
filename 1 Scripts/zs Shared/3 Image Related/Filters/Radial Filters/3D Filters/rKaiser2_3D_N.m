%------------------------------------------
%  Radial Kaiser Filter (3D)
%------------------------------------------

function [F F0] = rKaiser2_3D_N(Ksz,p,beta)

F = @(r) (((1/p)-1)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)))+1;
F0 = F(0);

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            F(x,y,z) = ((((1/p)-1)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)))+1)/F0;
            if r > 1
                F(x,y,z) = 0;
            end
        end
    end
end

%test = max(max(max(F)))
%F = F/max(max(max(F)));



