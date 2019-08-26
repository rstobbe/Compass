%------------------------------------------
%  Radial 1/r Filter
%------------------------------------------

function F = rINV_3D_N(Ksz,p)

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

F = F/max(max(max(F)));



