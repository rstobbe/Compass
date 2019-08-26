%====================================================
% 
%       
%====================================================

function Filt = Kaiser2D_v1b(x,y,beta,type)

if strcmp(type,'unsym')
    x = x+1;
    y = y+1;
end

Filtx = zeros(x,y);
for a = 1:y 
    Filtx(:,a) = kaiser(x,beta);
end

Filty = zeros(x,y);
for a = 1:x 
    Filty(a,:) = kaiser(y,beta);
end

Filt = Filtx .* Filty;

if strcmp(type,'unsym')
    Filt = Filt(1:x-1,1:y-1);
end