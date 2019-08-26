%================================================
%  
%================================================

function [ANLZ,err] = Anlz_TPI_v1f_Func(ANLZ,INPUT)

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
projindx = IMP.PSMP.PCD.projindx;
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
% Relative Error
%--------------------------------------
[Emat] = SDCArr2Mat(E,PROJimp.nproj,PROJimp.npro);
tdp = PROJimp.npro*PROJimp.nproj;
ANLZ.MeanAbsErrTrajArr = (sum(abs(Emat))/PROJimp.nproj)*100;
ANLZ.MeanAbsErrTot(j) = (sum(abs(Emat(:)))/tdp)*100;
if ANLZ.MeanAbsErrTot(j) > 100
    ANLZ.MeanAbsErrTot(j) = 100;
end
ANLZ.CErr(j) = ANLZ.MeanAbsErrTrajArr(1);
if ANLZ.CErr(j) > 100
    ANLZ.CErr(j) = 100;
end
for n = 1:length(projindx)
    ANLZ.MeanAbsErrCones(n) = (sum(sum(abs(Emat(projindx{n},:))))/(length(projindx{n})*PROJimp.npro))*100;
end

%--------------------------------------
% Sampling Efficiency
%--------------------------------------
[SDCmat] = SDCArr2Mat(SDC,PROJimp.nproj,PROJimp.npro);
ANLZ.MeanSDCTrajArr = mean(SDCmat,1);
ANLZ.Eff(j) = Efficiency_Test(PROJimp.npro,PROJimp.nproj,SDCmat);

%--------------------------------------
% Display
%--------------------------------------
Iteration = (j)
MeanAbsErrTot = ANLZ.MeanAbsErrTot(j)
Eff = ANLZ.Eff(j)
TrajAveSDC = mean(SDCmat(:,1:10))
MeanAbsErrTrajArr = ANLZ.MeanAbsErrTrajArr(1:10)

%--------------------------------------
% Figures
%--------------------------------------
[ArrKmat] = KMat2Arr(Kmat,PROJimp.nproj,PROJimp.npro);
rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/(PROJimp.meanrelkmax*PROJdgn.kmax);
ANLZ.rads = rads;

%Vis = 'On';
if strcmp(ANLZ.visuals,'On');
   
    figure(51);
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
    plot(ANLZ.MeanAbsErrTrajArr,'r*');
    title('Average Absolute Error (%) Along Trajectory'); xlabel('sampling point number');    
    
    figure(55);
    plot(rads,rSDCchg,'r*');
    title('relative SDC change'); xlabel('relative radial dimension');

    figure(56);
    plot(ANLZ.MeanSDCTrajArr,'r*');
    title('Mean SDC Along Trajectory'); xlabel('sampling point number');   
    
    figure(57);
    plot(ANLZ.MeanAbsErrCones,'r*');
    title('Mean Absolute Error on Cones'); xlabel('cone number');       
end
