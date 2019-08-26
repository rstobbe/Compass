%------------------------------------------
%  Radial Rect Filter for Gibbs Ringing
%------------------------------------------

function F = rRect_3D(Ksz)

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            F(x,y,z) = 1;
            if r > 1
                F(x,y,z) = 0;
            end
        end
    end
end

%test = max(max(max(F)))
%F = F/max(max(max(F)));



