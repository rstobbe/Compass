%------------------------------------------
%  Box Filter
%------------------------------------------

function Filt = Box_Filter(x,y,z)

BW = 0.5;
Filtx = zeros(x,y,z);
Filty = zeros(x,y,z);
Filtz = zeros(x,y,z);
Filt = zeros(x,y,z);

for a = -y/2:y/2-1 
    for b = -z/2:z/2-1
        if abs(a/(y/2)) < BW & abs(b/(z/2)) < BW
            Filtx(:,a+y/2+1,b+z/2+1) = 1;
        else
            Filtx(:,a+y/2+1,b+z/2+1) = 0;
        end
    end
end

for a = -x/2:x/2-1 
    for b = -z/2:z/2-1
        if abs(a/(x/2)) < BW & abs(b/(z/2)) < BW
            Filty(a+x/2+1,:,b+z/2+1) = 1;
        else
            Filty(a+x/2+1,:,b+z/2+1) = 0;
        end
    end
end

for a = -x/2:x/2-1 
    for b = -y/2:y/2-1
        if abs(a/(x/2)) < BW & abs(b/(y/2)) < BW
            Filtz(a+x/2+1,b+y/2+1,:) = 1;
        else
            Filtz(a+x/2+1,b+y/2+1,:) = 0;
        end
    end
end

Filt = Filtx .* Filty .* Filtz;






