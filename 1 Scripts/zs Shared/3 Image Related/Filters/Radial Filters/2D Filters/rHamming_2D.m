%------------------------------------------
%  Radial Hamming Filter for Gibbs Ringing
%------------------------------------------

function F = rHamming_2D(R)

F = zeros(R,R,'single');
for x = 1:R
    for y = 1:R
        r = sqrt((x-(R+1)/2)^2/((R-1)/2)^2 + (y-(R+1)/2)^2/((R-1)/2)^2);
        F(x,y) = 0.54 - 0.46*cos(pi*(1+r));
        if r > 1
            F(x,y) = 0;
        end
    end
end





