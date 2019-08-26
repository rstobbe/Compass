%==================================================
% Find Neighbors of Each Sampling Point
% (v1) - global search
% (b) - Kmat input = nproj x npro matrix
%     - NGH output ordered from centre out (as CUDA)
%==================================================

function [NGH,error,errorflag] = FindNghbrs_v1b(Kmat,W,AIDrp) 

error = '';
errorflag = 0;

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;

NGH = cell(1,length(AIDrp.npro*AIDrp.nproj));

n = 0;
for i = 1:AIDrp.npro
    for j = 1:AIDrp.nproj
        goodIndsX = uint32(find(abs(Kx - Kx(j,i)) <= W/2));           
        if isempty(goodIndsX)
            continue;
        end
        Kygood = Ky(goodIndsX);
        goodIndsY = goodIndsX(abs(Kygood - Ky(j,i)) <= W/2);
        if isempty(goodIndsY)
            continue;
        end
        Kzgood = Kz(goodIndsY);   
        goodIndsZ = (goodIndsY(abs(Kzgood - Kz(j,i)) <= W/2));
        if isempty(goodIndsZ)
            continue;
        end
        n = n+1;
        NGH{n} = goodIndsZ;
    end
    Status('busy',['Find Neighbours - Trajectory Sample Number: ',num2str(i)]);
end



