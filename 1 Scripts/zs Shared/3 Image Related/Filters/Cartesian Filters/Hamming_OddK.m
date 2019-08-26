%------------------------------------------
%   Hamming Filter for Gibbs Ringing
%------------------------------------------

function Filt = Hamming_Filter(x,y,z)

grid = zeros(x,y,z);
array = (-(x-1)/2:(x-1)/2);
for a = 1:y 
    for b = 1:z
        grid(:,a,b) = array;
    end
end
Filtx = 0.54 + 0.46*cos((grid*pi)/(x/2));

grid = zeros(x,y,z);
array = (-(y-1)/2:(y-1)/2);
for a = 1:x 
    for b = 1:z
        grid(a,:,b) = array;
    end
end
Filty = 0.54 + 0.46*cos((grid*pi)/(y/2));

grid = zeros(x,y,z);
array = (-(z-1)/2:(z-1)/2);
for a = 1:x 
    for b = 1:y
        grid(a,b,:) = array;
    end
end
Filtz = 0.54 + 0.46*cos((grid*pi)/(z/2));

Filt = Filtx .* Filty .* Filtz;





