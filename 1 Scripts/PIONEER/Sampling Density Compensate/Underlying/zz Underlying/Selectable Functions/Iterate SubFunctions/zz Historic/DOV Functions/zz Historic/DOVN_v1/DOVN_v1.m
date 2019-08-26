%===========================================================================================
%
%===========================================================================================

function [DOV,SDCS,error,errorflag] = DOVN_v1(Kmat,AIDrp,AIDimp,PROJdgn,SDCS,SDCipt,SDconv,visuals)

SDCS.RadSclFunc = SDCipt(strcmp('RadSclFunc',{SDCipt.labelstr})).entrystr;

normss = 1;
[Ksz,Kx,Ky,Kz,C,error,errorflag] = NormProjGrid_v2a(Kmat,AIDimp,AIDrp,SDCS,normss);
if errorflag == 1
    return
end

if strcmp(SDCS.RadSclFunc,'KmaxDesign');
    armax = PROJdgn.rad;
elseif strcmp(SDCS.RadSclFunc,'KmaxImp');
    armax = AIDimp.impkmax/AIDrp.kstep;
end
armaxtest = max(sqrt((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2));
if (abs(armaxtest-armax))/armax > 0.01
    errorflag = 1;
    error = 'Should Normalize to KmaxImp';
end

rx = (Kx-C)/armax;
ry = (Ky-C)/armax;
rz = (Kz-C)/armax;
rads = sqrt(rx.^2 + ry.^2 + rz.^2);

DOV = zeros(size(Kx),'single');
for n = 1:AIDrp.npro
    for m = 1:AIDrp.nproj
        DOV(m,n) = lin_interp4(SDconv,rads(m,n),SDCS.ConvTFRadDim);
    end
end

if visuals == 0
    figure(100); hold on;
    plot(SDCS.ConvTFRad,SDconv,'b-*');
    [ArrKmat] = KMat2Arr(Kmat,AIDrp.nproj,AIDrp.npro);
    rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/(armax*AIDrp.kstep);
    if AIDrp.nproj ~= 1
        [ArrDOV] = DatMat2Arr(DOV,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrDOV,'r*');
    else
        plot(rads,DOV,'r*');
    end
    title('Required Values at Sampling Point Locations');
end

