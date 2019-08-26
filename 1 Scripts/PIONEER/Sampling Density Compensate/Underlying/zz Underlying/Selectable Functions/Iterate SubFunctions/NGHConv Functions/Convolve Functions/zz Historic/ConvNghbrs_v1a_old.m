%==================================================
% Convolve Sampling Points Onto Themselves
% (v1a) - goes with FindNghbrs_v1a
%==================================================

function [CV] = ConvNghbrs_v1a(NGH,Kmat,DATR,SDCS,Krn,iKrnRes,AIDrp) 

szKrn = size(Krn);

Kx = SDCS.subsamp*Kmat(1,:)/AIDrp.kstep;                 
Ky = SDCS.subsamp*Kmat(2,:)/AIDrp.kstep;  
Kz = SDCS.subsamp*Kmat(3,:)/AIDrp.kstep;
	
CV = zeros(1,length(Kx));
for i = 1:length(Kx)
    %test = (((Kx(NGH{i}) - Kx(i))*iKrnRes).^2 + ((Ky(NGH{i}) - Ky(i))*iKrnRes).^2 + ((Kz(NGH{i}) - Kz(i))*iKrnRes).^2).^0.5
    KrnVals = Krn(round(abs(Kx(NGH{i}) - Kx(i))*iKrnRes)+1 + ...
                round(abs(Ky(NGH{i}) - Ky(i))*iKrnRes)*szKrn(1) + ...
                round(abs(Kz(NGH{i}) - Kz(i))*iKrnRes)*szKrn(1)*szKrn(2));
    CV(i) = sum(KrnVals .* DATR(NGH{i}));
    if rem(i,1000) == 0
        Status('busy',['Convolve Neighbours - kSpace Sample Number: ',num2str(i)]);
    end
end


