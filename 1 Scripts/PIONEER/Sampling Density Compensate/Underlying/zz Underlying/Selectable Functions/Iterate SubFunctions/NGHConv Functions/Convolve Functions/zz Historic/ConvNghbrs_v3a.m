%==================================================
% Convolve Sampling Points Onto Themselves
% - v3 = goes with FindNeighbors_v3
%==================================================

function [CV] = ConvNghbrs_v3a(NGH,Kx0,Ky0,Kz0,DATR0,W,beta,KrnRes,Ksz,PROJdgn,AIDrp,stat_tag)

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

KB = KaiBesImg_Half(W,beta,KrnRes,2*ceil(W/2)+2);
szKB = size(KB);

Kxr0 = round(Kx0*iKrnRes);	
Kyr0 = round(Ky0*iKrnRes);	
Kzr0 = round(Kz0*iKrnRes);	

C = ((Ksz+1)/2)*iKrnRes;
rad = sqrt((Kxr0(AIDrp.nproj,:)-C).^2 + (Kyr0(AIDrp.nproj,:)-C).^2 + (Kzr0(AIDrp.nproj,:)-C).^2);
V = (W/2)*iKrnRes;

[J,I] = size(Kxr0);
CV = zeros(J,I);
for i = 1:I
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
        Kxr = Kxr0(iprojs,iro);
        Kyr = Kyr0(iprojs,iro);
        Kzr = Kzr0(iprojs,iro);
        DATR = DATR0(iprojs,iro);
        for j = 1:nprojcone(k) 
            KBgood = KB(abs(Kxr(NGH{projoncone(j),i}) - Kxr0(projoncone(j),i))+1 + ...
                       (abs(Kyr(NGH{projoncone(j),i}) - Kyr0(projoncone(j),i))) * szKB(1) + ...
                       (abs(Kzr(NGH{projoncone(j),i}) - Kzr0(projoncone(j),i))) * szKB(1)*szKB(2));

            CV(projoncone(j),i) = sum(KBgood .* DATR(NGH{projoncone(j),i}));
        end
    end
    set(stat_tag,'String',strcat('Readout Points:_',num2str(i))); 
    drawnow;
end


