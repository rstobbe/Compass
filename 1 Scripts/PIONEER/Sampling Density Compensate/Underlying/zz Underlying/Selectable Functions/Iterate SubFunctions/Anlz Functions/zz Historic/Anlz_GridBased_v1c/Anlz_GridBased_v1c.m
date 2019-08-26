%================================================
%  (v1c)
%       - update for RWSUI_BA
%================================================

function [SCRPTipt,ANLZout,err] = Anlz_GridBased_v1c(SCRPTipt,ANLZ)

Status2('done','Analyze SDC',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJimp = ANLZ.PROJimp;
PROJdgn = ANLZ.PROJdgn;
Kmat = ANLZ.Kmat;
E = ANLZ.E;
DOV = ANLZ.DOV;
W = ANLZ.W;
SDC = ANLZ.SDC;
rSDCchg = ANLZ.rSDCchg;
j = ANLZ.j;

%---------------------------------------------
% Store Current for Possible Saving
%---------------------------------------------
ANLZout.E = E;
ANLZout.DOV = DOV;
ANLZout.W = W;

%--------------------------------------
% Calculate Relative Error
%--------------------------------------
[Emat] = SDCArr2Mat(E,PROJimp.nproj,PROJimp.npro);

%--------------------------------------
% Sampling Efficiency
%--------------------------------------
[SDCmat] = SDCArr2Mat(SDC,PROJimp.nproj,PROJimp.npro);
ANLZout.Eff(j) = Efficiency_Test(PROJimp.npro,PROJimp.nproj,SDCmat);

%--------------------------------------
% Display
%--------------------------------------
tdp = PROJimp.npro*PROJimp.nproj;
ANLZout.TrajErrArr = sign(mean(Emat)).*(sum(abs(Emat))/PROJimp.nproj)*100;
ANLZout.AErr(j) = (sum(abs(Emat(:)))/tdp)*100;
if ANLZout.AErr(j) > 100
    ANLZout.AErr(j) = 100;
end
ANLZout.CErr(j) = ANLZout.TrajErrArr(1);
if ANLZout.CErr(j) > 100
    ANLZout.CErr(j) = 100;
end

Iteration = (j)
AErr = ANLZout.AErr(j)
Eff = ANLZout.Eff(j)
TrajAveSDC = mean(SDCmat(:,1:10))
TrajErr = ANLZout.TrajErrArr(1:10)

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
    plot(ANLZout.TrajErrArr,'r*');
    title('Average Absolute Error (%) Along Trajectory'); xlabel('sampling point number');    
    
    figure(55);
    plot(rads,rSDCchg,'r*');
    title('relative SDC change'); xlabel('relative radial dimension');
end
