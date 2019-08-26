%==================================================
% Find Neighbors of Each Sampling Point
% - radial acceleration
%==================================================

function [NGH] = FindNghbrs_v2a(Kx0,Ky0,Kz0,W,KrnRes,AIDrp,PROJdgn,Ksz,stat_tag)

if not(round(1000*W/KrnRes) == 1000*round(W/KrnRes))
    error
end
if not(round(1000/KrnRes) == 1000*round(1/KrnRes))
    error
end
iKrnRes = round(1/KrnRes);

Kxr = round(Kx0*iKrnRes);	
Kyr = round(Ky0*iKrnRes);	
Kzr = round(Kz0*iKrnRes);		

C = ((Ksz+1)/2)*iKrnRes;
rad = sqrt((Kxr(AIDrp.nproj,:)-C).^2 + (Kyr(AIDrp.nproj,:)-C).^2 + (Kzr(AIDrp.nproj,:)-C).^2);
V = (W/2)*iKrnRes;

NGH = cell(AIDrp.nproj,AIDrp.npro);
%tot = 0;
for i = 1:AIDrp.npro
    inds = find((rad(i)-(V*1.8) <= rad) & (rad <= rad(i)+(V*1.8)));
    for j = 1:AIDrp.nproj 
        goodIndsX = uint32(find(abs(Kxr(:,inds) - Kxr(j,i)) <= V));           
        if isempty(goodIndsX)
            error
            continue;
        end
        Kyr2 = Kyr(:,inds);
        Kyrgood = Kyr2(goodIndsX);
        goodIndsY = goodIndsX(abs(Kyrgood - Kyr(j,i)) <= V);
        if isempty(goodIndsY)
            error
            continue;
        end
        Kzr2 = Kzr(:,inds);
        Kzrgood = Kzr2(goodIndsY);
        goodIndsZ = (goodIndsY(abs(Kzrgood - Kzr(j,i)) <= V));
        if isempty(goodIndsZ)
            error
            continue;
        end  
        NGH{j,i} = goodIndsZ;
        %tot = tot+length(goodIndsZ);
    end
    set(stat_tag,'String',['Find Neighbours - Trajectory Sample Number: ',num2str(i)]);
    drawnow;
end
%whos
%tot

