%------------------------------------------
%  Radial Hamming Filter for Gibbs Ringing
%------------------------------------------

function F = rHamming_1D(R)

F = zeros(R,1,'single');
for x = 1:R
    r = abs((x-(R+1)/2)/((R-1)/2));
    F(x) = 0.54 - 0.46*cos(pi*(1+r));
    if r > 1
        F(x) = 0;
    end
end





