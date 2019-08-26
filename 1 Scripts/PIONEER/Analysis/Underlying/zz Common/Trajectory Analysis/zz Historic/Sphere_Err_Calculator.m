%======================================================
%
%======================================================

function Sphere_Err_Calculator

R = (15:0.1:30);
Tot = zeros(1,length(R));
for m = 1:length(R)
    Ksz = 2*ceil(R(m))+1;   
    Tot(m) = 0;
    for x = 1:Ksz
        for y = 1:Ksz
            for z = 1:Ksz
                r = sqrt((x-(Ksz+1)/2)^2 + (y-(Ksz+1)/2)^2 + (z-(Ksz+1)/2)^2);
                if r <= R(m)
                    Tot(m) = Tot(m) + 1;
                end
            end
        end
    end 
end

compV = pi*(4/3)*R.^3;
Dif = compV./Tot;
test1 = max(Dif)
test2 = min(Dif)