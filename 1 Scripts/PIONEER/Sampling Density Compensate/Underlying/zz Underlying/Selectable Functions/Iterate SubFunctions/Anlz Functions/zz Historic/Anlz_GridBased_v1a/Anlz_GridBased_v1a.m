%===========================================================================================

%===========================================================================================

function [SDCS] = Anlz_GridBased_v1a(SDCS,E,PROJdgn,PROJimp,SDC,j)

[E] = SDCArr2Mat(E,PROJdgn.nproj,PROJimp.npro);
[SDC] = SDCArr2Mat(SDC,PROJdgn.nproj,PROJimp.npro);

tdp = PROJimp.npro*PROJdgn.nproj;
SDCS.TrajErrArr = sign(mean(E)).*(sum(abs(E))/PROJdgn.nproj)*100;
SDCS.AErr(j) = (sum(abs(E(:)))/tdp)*100;
if SDCS.AErr(j) > 100
    SDCS.AErr(j) = 100;
end
SDCS.CErr(j) = SDCS.TrajErrArr(1);
if SDCS.CErr(j) > 100
    SDCS.CErr(j) = 100;
end
SDCS.Eff(j) = Efficiency_Test(PROJimp.npro,PROJdgn.nproj,SDC);

Iteration = (j)
AErr = SDCS.AErr(j)
Eff = SDCS.Eff(j)
TrajAveSDC = mean(SDC(:,1:10))
TrajErr = SDCS.TrajErrArr(1:10)

