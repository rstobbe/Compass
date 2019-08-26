%=========================================================
% Quantize Projections - variable timings
%=========================================================

function [GQKSA] = Quantize_Projections_VT(AIDrp,T,qT,KSA)

tro = AIDrp.tro;
%nproj = AIDrp.nproj;
nproj = length(KSA(:,1,1));

npg = length(qT);
GQKSA = zeros(nproj,npg,3);

for n = 1:nproj
    for p = 1:3
        realt = tro*T(n,:)/max(T(n,:));
        GQKSA(n,:,p) = interp1(realt,KSA(n,:,p),qT);
    end
end

%--------------
show = 0;
if show == 1
    figure;
    hold on
    plot(realt,KSA(:,1),'r-');
    plot(qT,GQKSA(1,:,1),'b*');      
    figure;
    hold on
    plot(realt,KSA(:,2),'r-');
    plot(qT,GQKSA(1,:,2),'b*');      
    figure;
    hold on
    plot(realt,KSA(:,3),'r-');
    plot(qT,GQKSA(1,:,3),'b*'); 
    figure;
    hold on
    KSAabs = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);  
    GQKSAabs = sqrt(GQKSA(1,:,1).^2 + GQKSA(1,:,2).^2 + GQKSA(1,:,3).^2); 
    plot(realt,KSAabs,'r-');
    plot(qT,GQKSAabs,'b*');
    error
end
%--------------        

