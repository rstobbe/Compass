%================================================
%  (v1b)
%       - changes to input / output
%================================================

function [E,SDCS,SCRPTipt,err] = Anlz_GridBased_v1b(Kmat,DOV,W,SDC,rSDCchg,SDCS,PROJimp,j,SCRPTipt,err)

%Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr;
%if iscell(Vis)
%    Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('CTFvis',{SCRPTipt.labelstr})).entryvalue};
%end
Vis = 'On';

%--------------------------------------
% Calculate Relative Error
%--------------------------------------
E = 1 - (DOV ./ W);
[Emat] = SDCArr2Mat(E,PROJimp.nproj,PROJimp.npro);

%--------------------------------------
% Sampling Efficiency
%--------------------------------------
[SDCmat] = SDCArr2Mat(SDC,PROJimp.nproj,PROJimp.npro);
SDCS.Eff(j) = Efficiency_Test(PROJimp.npro,PROJimp.nproj,SDCmat);

%--------------------------------------
% Display
%--------------------------------------
tdp = PROJimp.npro*PROJimp.nproj;
SDCS.TrajErrArr = sign(mean(Emat)).*(sum(abs(Emat))/PROJimp.nproj)*100;
SDCS.AErr(j) = (sum(abs(Emat(:)))/tdp)*100;
if SDCS.AErr(j) > 100
    SDCS.AErr(j) = 100;
end
SDCS.CErr(j) = SDCS.TrajErrArr(1);
if SDCS.CErr(j) > 100
    SDCS.CErr(j) = 100;
end

Iteration = (j)
AErr = SDCS.AErr(j)
Eff = SDCS.Eff(j)
TrajAveSDC = mean(SDCmat(:,1:10))
TrajErr = SDCS.TrajErrArr(1:10)

%--------------------------------------
% Figures
%--------------------------------------
if strcmp(Vis,'On');
    figure(51);
    [ArrKmat] = KMat2Arr(Kmat,PROJimp.nproj,PROJimp.npro);
    rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/SDCS.compkmax;
    plot(rads,SDC,'r*');
    title('SDC Values at Sampling Point Locations'); xlabel('relative radial dimension');

    figure(52); clf(52); hold on;
    plot(rads,DOV,'k*');
    plot(rads,W,'r*');
    title('Output Values at Sampling Point Locations'); xlabel('relative radial dimension');

    figure(53);
    plot(rads,E*100,'r*');
    title('Error (%) at Sampling Point Locations'); xlabel('relative radial dimension');

    figure(54);
    plot(SDCS.TrajErrArr,'r*');
    title('Average Absolute Error (%) Along Trajectory'); xlabel('sampling point number');    
    
    figure(55);
    plot(rads,rSDCchg,'r*');
    title('relative SDC change'); xlabel('relative radial dimension');
end
