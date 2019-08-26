%------------------------------------------
%  Radial Hanning Filter for Gibbs Ringing
%------------------------------------------

function F = rHanning(R)

F = zeros(R,R,R,'single');
for x = 1:R
    for y = 1:R
        for z = 1:R
            r = sqrt((x-(R+1)/2)^2/((R-1)/2)^2 + (y-(R+1)/2)^2/((R-1)/2)^2 + (z-(R+1)/2)^2/((R-1)/2)^2);
            F(x,y,z) = 0.5 - 0.5*cos(pi*(1+r));
            if r > 1
                F(x,y,z) = 0;
            end
        end
    end
end





