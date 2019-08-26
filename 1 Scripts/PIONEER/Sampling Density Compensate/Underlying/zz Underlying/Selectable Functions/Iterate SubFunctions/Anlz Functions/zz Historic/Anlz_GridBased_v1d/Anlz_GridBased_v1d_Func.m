%================================================
%  
%================================================

function [ANLZ,err] = Anlz_GridBased_v1d_Func(ANLZ,INPUT)

Status2('done','Analyze SDC',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
IMP = INPUT.IMP;
PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
Kmat = IMP.Kmat;
E = INPUT.E;
DOV = INPUT.DOV;
W = INPUT.W;
SDC = INPUT.SDC;
rSDCchg = INPUT.rSDCchg;
j = INPUT.j;
clear INPUT

%---------------------------------------------
% Store Current for Possible Saving
%---------------------------------------------
ANLZ.E = E;
ANLZ.DOV = DOV;
ANLZ.W = W;

%--------------------------------------
% Calculate Relative Error
%--------------------------------------
[Emat] = SDCArr2Mat(E,PROJimp.nproj,PROJimp.npro);

%--------------------------------------
% Sampling Efficiency
%--------------------------------------
[SDCmat] = SDCArr2Mat(SDC,PROJimp.nproj,PROJimp.npro);
ANLZ.Eff(j) = Efficiency_Test(PROJimp.npro,PROJimp.nproj,SDCmat);

%--------------------------------------
% Display
%--------------------------------------
tdp = PROJimp.npro*PROJimp.nproj;
ANLZ.TrajErrArr = sign(mean(Emat)).*(sum(abs(Emat))/PROJimp.nproj)*100;
ANLZ.AErr(j) = (sum(abs(Emat(:)))/tdp)*100;
if ANLZ.AErr(j) > 100
    ANLZ.AErr(j) = 100;
end
ANLZ.CErr(j) = ANLZ.TrajErrArr(1);
if ANLZ.CErr(j) > 100
    ANLZ.CErr(j) = 100;
end

Iteration = (j)
AErr = ANLZ.AErr(j)
Eff = ANLZ.Eff(j)
TrajAveSDC = mean(SDCmat(:,1:10))
TrajErr = ANLZ.TrajErrArr(1:10)

%--------------------------------------
% Figures
%--------------------------------------
Vis = 'On';
if strcmp(Vis,'On');
    figure(51);
    [ArrKmat] = KMat2Arr(Kmat,PROJimp.nproj,PROJimp.npro);
    rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/(PROJimp.meanrelkmax*PROJdgn.kmax);
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
    plot(ANLZ.TrajErrArr,'r*');
    title('Average Absolute Error (%) Along Trajectory'); xlabel('sampling point number');    
    
    figure(55);
    plot(rads,rSDCchg,'r*');
    title('relative SDC change'); xlabel('relative radial dimension');
end
