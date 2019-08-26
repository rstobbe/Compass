%==================================================
% NGH:  [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% Kmat:  (nproj x npro x 3)
% CV:  (nproj x npro)
%==================================================

function [CV] = ConvNghbrs_v1a(NGH,Kmat,DATR,Krn,iKrnRes,AIDrp) 

szKrn = size(Krn);

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;

CV = zeros(AIDrp.nproj,AIDrp.npro);
n = 0;
for i = 1:AIDrp.npro
    for j = 1:AIDrp.nproj 
        n = n+1;
        %test = (((Kx(NGH{n}) - Kx(j,i))*iKrnRes).^2 + ((Ky(NGH{n}) - Ky(j,i))*iKrnRes).^2 + ((Kz(NGH{n}) - Kz(j,i))*iKrnRes).^2).^0.5
        KrnVals = Krn(round(abs(Kx(NGH{n}) - Kx(j,i))*iKrnRes)+1 + ...
                    round(abs(Ky(NGH{n}) - Ky(j,i))*iKrnRes)*szKrn(1) + ...
                    round(abs(Kz(NGH{n}) - Kz(j,i))*iKrnRes)*szKrn(1)*szKrn(2));
        CV(j,i) = sum(KrnVals .* DATR(NGH{n}));
    end
    Status2('busy',['Convolve Neighbours - Trajectory Sample Number: ',num2str(i)],3);
end        
Status2('done','',3);


