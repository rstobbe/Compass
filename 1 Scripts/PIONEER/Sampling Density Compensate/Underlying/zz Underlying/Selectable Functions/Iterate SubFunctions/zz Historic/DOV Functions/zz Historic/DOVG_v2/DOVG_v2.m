%=========================================================
%
%=========================================================

function [DOV,SDCS,Ksz,Kx,Ky,Kz,err] = DOVG_v2(Kmat,PROJdgn,PROJimp,CTF,SDCS,KRNprms,SCRPTipt,err)


kmax = (PROJimp.meanrelkmax*PROJdgn.kmax);
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,PROJdgn.nproj,PROJimp.npro,kmax,PROJdgn.kstep,KRNprms.W,SDCS.SubSamp,'M2A');

armax = (kmax/PROJdgn.kstep)*SDCS.SubSamp;
armaxtest = max(sqrt((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2));
if (abs(armaxtest-armax))/armax > 0.01
    error();
end

rx = (Kx-C)/armax;
ry = (Ky-C)/armax;
rz = (Kz-C)/armax;
rads = sqrt(rx.^2 + ry.^2 + rz.^2);

DOV = zeros(size(Kx),'single');
for n = 1:PROJimp.npro*PROJdgn.nproj
    DOV(n) = lin_interp4(CTF.SDconv,rads(n),CTF.rconv);
end

visuals = 1;
if visuals == 1
    figure(100); hold on;
    plot(SDCS.ConvTFRad,SDconv,'b-*');
    [ArrKmat] = KMat2Arr(Kmat,PROJdgn.nproj,PROJimp.npro);
    rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/(armax*PROJdgn.kstep/SDCS.SubSamp);
    plot(rads,DOV,'r*');
    title('Required Values at Sampling Point Locations');
end



