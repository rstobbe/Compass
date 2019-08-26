%====================================================
% GenHamN1 SDC Filter Function
%====================================================

function [SCRPTipt,GAMFUNCout,err] = GenHamN1_v1a(SCRPTipt,GAMFUNC)

err.flag = 0;

GamFunc = @(r,p) (1+((1/p - 1)/(1 - cos(pi*(1+p)))) - ((1/p - 1)/(1 - cos(pi*(1+p))))*(cos(pi*(1+r))))/p;

if strcmp(GAMFUNC.setup,'yes');
    GAMFUNCout.GamFunc = GamFunc;
    return
end

GAMFUNCout.GamFunc = GamFunc;
GAMFUNCout.r = GAMFUNC.r;
GAMFUNCout.p = GAMFUNC.p;
GAMFUNCout.GamShape = GamFunc(GAMFUNC.r,GAMFUNC.p);

