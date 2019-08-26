%====================================================
% GenHamN1 SDC Filter Function
%====================================================

function [SCRPTipt,GAMFUNC,err] = CentreExtendGenHamN1_v1a(SCRPTipt,GAMFUNC)

err.flag = 0;

GAMFUNC.GamFunc = @(r,p) (1+((1/p - 1)/(1 - cos(pi*(1+p)))) - ((1/p - 1)/(1 - cos(pi*(1+p))))*(cos(pi*(1+r))))/p;

figure(1); hold on;
r = (0:0.001:1);
p = 0.13;
plot(r,GAMFUNC.GamFunc(r,p)*p);
xlabel('Relative Radius');
ylabel('Gamma Function');
ylim([0 10]);

error('not finished');

if strcmp(GAMFUNC.setup,'yes');
    return
end

GAMFUNC.GamShape = GAMFUNC.GamFunc(GAMFUNC.r,GAMFUNC.p);

