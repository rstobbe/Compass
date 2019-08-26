%====================================================
% GenHamN1_Filter Function
%====================================================

function [SCRPTipt,GAMFUNC,err] = GenHamN1(SCRPTipt,GAMFUNC)

err.flag = 0;

GMVis = SCRPTipt(strcmp('GamFunc Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(GMVis)
    GMVis = SCRPTipt(strcmp('GamFunc Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('GamFunc Vis',{SCRPTipt.labelstr})).entryvalue};
end

%N = 1;
%s2 = ((1/p - 1)/(1 - cos(pi*(1+p))));          
%s1 = s2 + N;
%GAMFUNC.GamFunc = @(r) (s1 - s2*(cos(pi*(1+r))))/p;
GAMFUNC.GamFunc = @(r,p) (1+((1/p - 1)/(1 - cos(pi*(1+p)))) - ((1/p - 1)/(1 - cos(pi*(1+p))))*(cos(pi*(1+r))))/p;

if strcmp(GAMFUNC.setup,'yes');
    return
end

GAMFUNC.GamShape = GAMFUNC.GamFunc(GAMFUNC.r,GAMFUNC.p);
if strcmp(GMVis,'On')  
    figure(1); hold on;
    plot(GAMFUNC.r,GAMFUNC.GamShape);
    axis([0 1 0 1.1*max(GAMFUNC.GamShape)]);
    xlabel('Relative Radius');
    ylabel('Gamma Function');
    figure(2); hold on;
    plot(GAMFUNC.r,GAMFUNC.GamShape/max(GAMFUNC.GamShape),'r');
    axis([0 1 0 1.1]);
    xlabel('Relative Radius');
    ylabel('Relative Gamma Function');
end

