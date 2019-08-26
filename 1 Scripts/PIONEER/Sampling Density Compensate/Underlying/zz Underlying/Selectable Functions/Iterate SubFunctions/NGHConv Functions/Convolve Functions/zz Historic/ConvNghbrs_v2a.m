%==================================================
% Convolve Sampling Points Onto Themselves
% - v2 = goes with FindNghbrs_v2a
%==================================================

function [CV] = ConvNghbrs_v2a(NGH,Kx0,Ky0,Kz0,DATR0,W,beta,KrnRes,Ksz,PROJdgn,AIDrp,stat_tag)

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

for i = 1:AIDrp.npro
    inds = find((rad(i)-(V*1.8) <= rad) & (rad <= rad(i)+(V*1.8)));
    Kxr = Kxr0(:,inds);
    Kyr = Kyr0(:,inds);
    Kzr = Kzr0(:,inds);
    DATR = DATR0(:,inds);
    for j = 1:AIDrp.nproj 
        %test = ((Kxr(NGH{j,i}) - Kxr0(j,i)).^2 + (Kyr(NGH{j,1}) - Kyr0(j,i)).^2 + (Kzr(NGH{j,1}) - Kzr0(j,i)).^2).^0.5
        KBgood = KB(abs(Kxr(NGH{j,i}) - Kxr0(j,i))+1 + ...
                   (abs(Kyr(NGH{j,i}) - Kyr0(j,i))) * szKB(1) + ...
                   (abs(Kzr(NGH{j,i}) - Kzr0(j,i))) * szKB(1)*szKB(2));
        CV(j,i) = sum(KBgood .* DATR(NGH{j,i}));
    end
    set(stat_tag,'String',['Convolve - Trajectory Sample Number: ',num2str(i)]); 
    drawnow;
end        
        


