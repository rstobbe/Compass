%------------------------------------------
%  Radial Generalized Blackman Filter for Gibbs Ringing
%------------------------------------------

function F = rGBlack_3D(Ksz,p,C,S)

s3 = ((1/p) - ((C+S)/2) + ((C-S)/2)*cos(pi*(1+p)))/(cos(2*pi*(1+p))-1);
s2 = (C-S)/2;
s1 = (C+S)/2 - s3;

F0 = C;

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            F(x,y,z) = (s1 - s2*cos(pi*(1+r)) + s3*cos(2*pi*(1+r)))/F0;
            if r > 1
                F(x,y,z) = 0;
            end
        end
    end
end

%test = max(max(max(F)))
%F = F/max(max(max(F)));



