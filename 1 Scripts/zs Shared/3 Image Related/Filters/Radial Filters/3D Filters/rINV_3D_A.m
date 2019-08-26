%------------------------------------------
%  Radial 1/r Filter
%------------------------------------------

function [F F0] = rINV_3D_A(Ksz,p)

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            if r >= p && r <= 1
                F(x,y,z) = 1/r;
            elseif r < p
                F(x,y,z) = 1/p;
            elseif r > 1
                F(x,y,z) = 0;
            end
        end
    end
end

F0 = max(max(max(F)));



