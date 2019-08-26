%------------------------------------------
%  Radial Stobbe Filter for Gibbs Ringing
%------------------------------------------

function [F F0] = rStobbe_3D_N_2(Ksz,p,n)

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

s2 = (1/p - n)/(1 - cos(pi*(1+p)));
s1 = s2 + n;

F0 = s1 + s2;

F = zeros(Ksz,Ksz,Ksz,'single');
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r = sqrt((x-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (y-(Ksz+1)/2)^2/((Ksz-1)/2)^2 + (z-(Ksz+1)/2)^2/((Ksz-1)/2)^2);
            if (r <= M) 
                F(x,y,z) = (s1 - s2*cos(pi*(1+r)))/F0;
            end
        end
    end
end

