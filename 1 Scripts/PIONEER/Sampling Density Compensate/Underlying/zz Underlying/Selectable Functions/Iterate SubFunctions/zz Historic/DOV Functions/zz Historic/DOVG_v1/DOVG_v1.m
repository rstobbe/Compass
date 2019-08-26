%===========================================================================================
%
%===========================================================================================

function [DOV,SDCS,Ksz,Kx,Ky,Kz,KxB,KyB,KzB,error,errorflag] = DOVG_v1(Kmat,AIDrp,AIDimp,PROJdgn,SDCS,SDCipt,SDconv,visuals)

SDCS.RadSclFunc = SDCipt(strcmp('RadSclFunc',{SDCipt.labelstr})).entrystr;
SDCS.BackUpFunc = SDCipt(strcmp('BackUpFunc',{SDCipt.labelstr})).entrystr;

normss = SDCS.SubSamp;
[Ksz,Kx,Ky,Kz,C,error,errorflag] = NormProjGrid_v4(Kmat,AIDrp,AIDimp.impkmax,AIDrp.kstep,SDCS.W,normss,'M2A');

if errorflag == 1
    return
end

if strcmp(SDCS.RadSclFunc,'KmaxDesign');
    armax = PROJdgn.rad*SDCS.SubSamp;
elseif strcmp(SDCS.RadSclFunc,'KmaxImp');
    armax = (AIDimp.impkmax/AIDrp.kstep)*SDCS.SubSamp;
end
armaxtest = max(sqrt((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2));
if (abs(armaxtest-armax))/armax > 0.01
    errorflag = 1;
    error = 'Should Normalize to KmaxImp';
end

backupfunc = str2func(SDCS.BackUpFunc);
[KxB,KyB,KzB] = backupfunc(Kx,Ky,Kz,C,armax,PROJdgn.elip);
%KxB = Kx; KyB = Ky; KzB = Kz;

rx = (KxB-C)/armax;
ry = (KyB-C)/armax;
rz = (KzB-C)/armax;
rads = sqrt(rx.^2 + ry.^2 + rz.^2);

DOV = zeros(size(Kx),'single');
for n = 1:AIDrp.npro*AIDrp.nproj
    DOV(n) = lin_interp4(SDconv,rads(n),SDCS.ConvTFRadDim);
end

if visuals == 0
    figure(100); hold on;
    plot(SDCS.ConvTFRad,SDconv,'b-*');
    [ArrKmat] = KMat2Arr(Kmat,AIDrp.nproj,AIDrp.npro);
    rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/(armax*AIDrp.kstep/SDCS.SubSamp);
    plot(rads,DOV,'r*');
    title('Required Values at Sampling Point Locations');
end



