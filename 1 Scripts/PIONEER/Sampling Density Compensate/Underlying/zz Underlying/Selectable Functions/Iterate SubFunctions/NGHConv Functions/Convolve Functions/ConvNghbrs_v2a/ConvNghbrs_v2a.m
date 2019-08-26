%==================================================
% NGH:  [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% Kmat:  (nproj x npro x 3)
% CV:  (nproj x npro)
%==================================================

function [CV] = ConvNghbrs_v2a(NGH,KrnVals,DATR,AIDrp) 

CV = zeros(AIDrp.nproj,AIDrp.npro);
n = 0;
for i = 1:AIDrp.npro
    Status2('busy',['Convolve Neighbours - Trajectory Sample Number: ',num2str(i)],3);
    for j = 1:AIDrp.nproj 
        n = n+1;
        CV(j,i) = sum(KrnVals{n} .* DATR(NGH{n}));
    end
end        
Status2('done','',3);
