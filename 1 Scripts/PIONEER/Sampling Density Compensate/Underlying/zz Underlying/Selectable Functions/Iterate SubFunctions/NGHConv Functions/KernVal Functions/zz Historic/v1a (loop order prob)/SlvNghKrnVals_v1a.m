%==================================================
% NGH:  [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% Kmat:  (nproj x npro x 3)
% CV:  (nproj x npro)
%==================================================

function [KrnVals,error,errorflag] = SlvNghKrnVals_v1a(NGH,Kmat,KRNprms,SDCS,AIDrp) 

Status2('busy','Generate Convolution Kernel',2);
func = str2func(KRNprms.type);
%KRNprms.zW = 2*(ceil((KRNprms.W-2)/2)+1);
KRNprms.zW = KRNprms.W*1.2;
[KRNprms,error,errorflag] = func(KRNprms);
if errorflag == 1
    return
end
Krn = KRNprms.Kern;  
szKrn = size(Krn);

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;

Status2('busy','Kernel Values',2);
KrnVals = cell(1,AIDrp.nproj*AIDrp.npro);
n = 0;
for j = 1:AIDrp.nproj 
    for i = 1:AIDrp.npro
        n = n+1;
        %test = (((Kx(NGH{n}) - Kx(j,i))*SDCS.iKrnRes).^2 + ((Ky(NGH{n}) - Ky(j,i))*SDCS.iKrnRes).^2 + ((Kz(NGH{n}) - Kz(j,i))*SDCS.iKrnRes).^2).^0.5
        test = max(round(abs(Kx(NGH{n}) - Kx(j,i))*KRNprms.iKern)+1 + ...
                    round(abs(Ky(NGH{n}) - Ky(j,i))*KRNprms.iKern)*szKrn(1) + ...
                    round(abs(Kz(NGH{n}) - Kz(j,i))*KRNprms.iKern)*szKrn(1)*szKrn(2))
        KrnVals{n} = Krn(round(abs(Kx(NGH{n}) - Kx(j,i))*KRNprms.iKern)+1 + ...
                    round(abs(Ky(NGH{n}) - Ky(j,i))*KRNprms.iKern)*szKrn(1) + ...
                    round(abs(Kz(NGH{n}) - Kz(j,i))*KRNprms.iKern)*szKrn(1)*szKrn(2));
    end
    Status2('busy',['Trajectory Sample Number: ',num2str(i)],3);
end        
Status2('done','',3);


