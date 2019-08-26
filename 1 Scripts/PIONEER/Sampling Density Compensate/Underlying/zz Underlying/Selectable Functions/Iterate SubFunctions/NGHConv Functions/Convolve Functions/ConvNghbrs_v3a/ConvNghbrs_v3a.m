%==================================================
% NGH:  [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% Kmat:  (nproj x npro x 3)
% CV:  (nproj x npro)
%==================================================

function [CV] = ConvNghbrs_v3a(NGH,KrnVals,DATR,AIDrp) 

CV = zeros(AIDrp.nproj,AIDrp.npro);
for j = 1:AIDrp.nproj 
    Status2('busy',['Convolve Neighbours - Trajectory Number: ',num2str(j)],3);
    for i = 1:AIDrp.npro
        n = j+(i-1)*AIDrp.nproj;
        CV(j,i) = sum(KrnVals{n} .* DATR(NGH{n}));
    end
end        
Status2('done','',3);
