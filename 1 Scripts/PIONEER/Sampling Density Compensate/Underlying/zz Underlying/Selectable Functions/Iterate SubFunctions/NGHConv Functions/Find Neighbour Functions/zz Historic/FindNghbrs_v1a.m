%==================================================
% Find Neighbors of Each Sampling Point
% (v1) - global search
% (a) - Kmat input = kSpace location array
%==================================================

function [NGH,error,errorflag] = FindNghbrs_v1a(Kmat,W,AIDrp) 

error = '';
errorflag = 0;

Kx = Kmat(1,:)/AIDrp.kstep;                 
Ky = Kmat(2,:)/AIDrp.kstep;  
Kz = Kmat(3,:)/AIDrp.kstep;

NGH = cell(1,length(Kx));

for i = 1:length(Kx)
    goodIndsX = uint32(find(abs(Kx - Kx(i)) <= W/2));           
    if isempty(goodIndsX)
        continue;
    end
    Kygood = Ky(goodIndsX);
    goodIndsY = goodIndsX(abs(Kygood - Ky(i)) <= W/2);
    if isempty(goodIndsY)
        continue;
    end
    Kzgood = Kz(goodIndsY);   
    goodIndsZ = (goodIndsY(abs(Kzgood - Kz(i)) <= W/2));
    if isempty(goodIndsZ)
        continue;
    end 
    NGH{i} = goodIndsZ;
    if rem(i,1000) == 0
        Status('busy',['Find Neighbours - kSpace Sample Number: ',num2str(i)]);
        i
    end
end


