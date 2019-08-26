%====================================================
% Kaiser Function
%====================================================

function [SCRPTipt,GAMFUNC,err] = Kaiser(SCRPTipt,GAMFUNC)

err.flag = 0;

GMVis = SCRPTipt(strcmp('GamFunc Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(GMVis)
    GMVis = SCRPTipt(strcmp('GamFunc Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('GamFunc Vis',{SCRPTipt.labelstr})).entryvalue};
end
beta = str2double( SCRPTipt(strcmp('Beta',{SCRPTipt.labelstr})).entrystr);

GAMFUNC.GamFunc = @(r,p) (1/p^2)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)); 

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
