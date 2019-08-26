%------------------------------------------
%  Radial Stobbe Filter for Gibbs Ringing (2D)
%------------------------------------------

function F = rStobbe(R,p)

s2 = (1-p)/(2-p-p*cos(pi*(1+p)));
s1 = 1-s2;

F = zeros(1,R,'single');
for x = 1:R
    r = (x-(R+1)/2)/((R-1)/2);
    F(x) = s1 - s2*cos(pi*(1+r));
    if r > 1
        F(x) = 0;
    end
end

%test = max(max(max(F)))
%F = F/max(max(max(F)));



