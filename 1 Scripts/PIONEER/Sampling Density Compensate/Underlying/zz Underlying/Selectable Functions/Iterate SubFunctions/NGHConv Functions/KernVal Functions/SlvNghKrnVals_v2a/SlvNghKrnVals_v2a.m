%==================================================
% NGH:  [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% Kmat:  (nproj x npro x 3)
% CV:  (nproj x npro)
%==================================================

function [KrnVals,error,errorflag] = SlvNghKrnVals_v2a(NGH,Kmat,KRNprms,SDCS,AIDrp) 

error = '';
errorflag = 0;

Krn = KRNprms.Kern;  
szKrn = size(Krn);

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;

Status2('busy','Solve Kernel Values at Neighbours',2);
KrnVals = cell(1,AIDrp.nproj*AIDrp.npro);
n = 0;
for i = 1:AIDrp.npro
    Status2('busy',['Trajectory Sample Number: ',num2str(i)],3);
    for j = 1:AIDrp.nproj 
        n = n+1;
        %test = (((Kx(NGH{n}) - Kx(j,i))*KRNprms.iKern).^2 + ((Ky(NGH{n}) - Ky(j,i))*KRNprms.iKern).^2 + ((Kz(NGH{n}) - Kz(j,i))*KRNprms.iKern).^2).^0.5
        KrnVals{n} = Krn(round(abs(Kx(NGH{n}) - Kx(j,i))*KRNprms.iKern)+1 + ...
                    round(abs(Ky(NGH{n}) - Ky(j,i))*KRNprms.iKern)*szKrn(1) + ...
                    round(abs(Kz(NGH{n}) - Kz(j,i))*KRNprms.iKern)*szKrn(1)*szKrn(2));
    end
end        
Status2('done','',3);


