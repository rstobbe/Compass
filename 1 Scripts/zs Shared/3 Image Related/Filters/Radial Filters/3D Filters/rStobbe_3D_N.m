%------------------------------------------
%  Radial Stobbe Filter for Gibbs Ringing
%------------------------------------------

function F = rStobbe_3D_N(Ksz,p,n)

s2 = (1/p - n)/(1 - cos(pi*(1+p)));
s1 = s2 + n;

F0 = s1 + s2;

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            F(x,y,z) = (s1 - s2*cos(pi*(1+r)))/F0;
            if r > 1
                F(x,y,z) = 0;
            end
        end
    end
end

%test = max(max(max(F)))
%F = F/max(max(max(F)));



