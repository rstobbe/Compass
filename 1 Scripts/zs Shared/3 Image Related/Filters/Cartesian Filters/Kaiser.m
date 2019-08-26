%====================================================
% 
%       
%====================================================

function Filt = Kaiser(x,y,z,beta)

Filtx = zeros(x,y,z);
for a = 1:y 
    for b = 1:z
        Filtx(:,a,b) = kaiser(x,beta);
    end
end

Filty = zeros(x,y,z);
for a = 1:x 
    for b = 1:z
        Filty(a,:,b) = kaiser(y,beta);
    end
end

Filtz = zeros(x,y,z);
for a = 1:x 
    for b = 1:y
        Filtz(a,b,:) = kaiser(z,beta);
    end
end

Filt = Filtx .* Filty .* Filtz;
