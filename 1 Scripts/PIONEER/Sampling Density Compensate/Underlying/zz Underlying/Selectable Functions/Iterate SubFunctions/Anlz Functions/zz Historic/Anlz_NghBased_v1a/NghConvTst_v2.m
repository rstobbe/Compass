%===========================================================================================

%===========================================================================================

function [SDCS] = NghConvTst_v2(SDCS,E,AIDrp,SDC,j)

if j == 1
    SDCS.AErr(1) = 100;
    SDCS.CErr(1) = 100;
    SDCS.CErr2(1) = 100;
    return
end  

tdp = AIDrp.npro*AIDrp.nproj;
if AIDrp.nproj == 1
    SDCS.TrajErrArr = E*100;
else
    SDCS.TrajErrArr = sign(mean(E)).*(sum(abs(E))/AIDrp.nproj)*100;
end
SDCS.AErr(j-1) = (sum(abs(E(:)))/tdp)*100;
SDCS.CErr(j-1) = SDCS.TrajErrArr(1);      
SDCS.CErr2(j-1) = SDCS.TrajErrArr(2); 
SDCS.Eff(j-1) = Efficiency_Test(AIDrp,SDC);

Iteration = j-1
AErr = SDCS.AErr(j-1)
Eff = SDCS.Eff(j-1)
%TrajAveSDC = mean(SDC(:,1:10))

TrajErr = SDCS.TrajErrArr(1:10)
%TrajErr2 = SDCS.TrajErrArr
