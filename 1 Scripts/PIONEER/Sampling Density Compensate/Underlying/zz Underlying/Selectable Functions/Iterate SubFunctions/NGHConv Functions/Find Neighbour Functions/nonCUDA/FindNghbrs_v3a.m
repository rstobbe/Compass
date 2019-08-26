%==================================================
% Find Neighbors of Each Sampling Point
% v3 - acceleration for TPI
%==================================================

function [NGH] = FindNeighbors_v3(Kx,Ky,Kz,W,KrnRes,AIDrp,PROJdgn,Ksz,stat_tag)

phi = PROJdgn.conephi;
projindx = PROJdgn.projindx;
nprojcone = PROJdgn.nprojcone;
ncones = PROJdgn.ncones;

if not(round(1000*W/KrnRes) == 1000*round(W/KrnRes))
    error
end
if not(round(1000/KrnRes) == 1000*round(1/KrnRes))
    error
end
iKrnRes = round(1/KrnRes);

Kxr = round(Kx*iKrnRes);	
Kyr = round(Ky*iKrnRes);	
Kzr = round(Kz*iKrnRes);	

NGH = cell(AIDrp.nproj,AIDrp.npro);

C = ((Ksz+1)/2)*iKrnRes;
rad = sqrt((Kxr(AIDrp.nproj,:)-C).^2 + (Kyr(AIDrp.nproj,:)-C).^2 + (Kzr(AIDrp.nproj,:)-C).^2);
V = (W/2)*iKrnRes;

for i = 1:AIDrp.npro
    inds1 = find(rad <= rad(i)-(V*1.8),1,'last');
    inds2 = find(rad(i)+(V*1.8) <= rad,1,'first');
    if isempty(inds1)
        inds1 = 1;
    end
    if isempty(inds2)
        inds2 = AIDrp.npro;
    end
    iro = (inds1:inds2);
    for k = 1:ncones
        icone = abs(sin(phi-phi(k))*rad(i)) < V*1.8; 
        iprojs = [projindx{icone}];
        projoncone = projindx{k};
        for j = 1:nprojcone(k) 
            goodIndsX = uint32(find(abs(Kxr(iprojs,iro) - Kxr(projoncone(j),i)) <= V));           
            if isempty(goodIndsX)
                error
                continue;
            end
            Kyr2 = Kyr(iprojs,iro);
            Kyrgood = Kyr2(goodIndsX);
            goodIndsY = goodIndsX(abs(Kyrgood - Kyr(projoncone(j),i)) <= V);
            if isempty(goodIndsY)
                error
                continue;
            end
            Kzr2 = Kzr(iprojs,iro);
            Kzrgood = Kzr2(goodIndsY);
            goodIndsZ = (goodIndsY(abs(Kzrgood - Kzr(projoncone(j),i)) <= V));
            if isempty(goodIndsZ)
                error
                continue;
            end  
            NGH{projoncone(j),i} = goodIndsZ;
        end
    end
    set(stat_tag,'String',strcat('Readout Points:_',num2str(i)));
    drawnow;
end
%whos

