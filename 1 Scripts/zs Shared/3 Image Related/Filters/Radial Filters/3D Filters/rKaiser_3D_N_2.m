%------------------------------------------
%  Radial Kaiser Filter (3D)
%------------------------------------------

function [F F0] = rKaiser_3D_N_2(Ksz,p,beta)

%(1.038 - 25) (1.035 - 31) (1.02 - 51)

if Ksz == 25
    M = 1.038;
elseif Ksz == 31
    M = 1.035;
elseif Ksz == 51
    M = 1.02;
else
    error('Ksz not defined');
end

F = @(r) (1/p)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2));
F0 = F(0);

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            if (r <= M) 
                F(x,y,z) = ((1/p)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)))/F0;
            end
        end
    end
end

