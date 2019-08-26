%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_SDshape_v1a(SCRPTipt,SCRPTGBL)

dr = zeros(1,slvno);
for m = 2:slvno
    dr(m) = (r(m)-r(m-1))/(relprojlen*T(m)/realT-relprojlen*T(m-1)/realT);
end
Gam = zeros(1,slvno);
Gam(2:slvno) = p^2./(dr(2:slvno).*r(2:slvno).^2);
Gam(1) = Gam(2);
itpRad = (0:0.01:1);
itpGam = interp1(r,Gam,itpRad);

figure(400); hold on; 
plot(itpRad,itpGam,'m','linewidth',2); 
xlim([0 1]); 
ylim([0 1.1*max(itpGam(10))]); 
xlabel('Relative k-Space Radius'); 
ylabel('Sampling Density'); 
title('Relative Radial k-Space Sampling Density');
