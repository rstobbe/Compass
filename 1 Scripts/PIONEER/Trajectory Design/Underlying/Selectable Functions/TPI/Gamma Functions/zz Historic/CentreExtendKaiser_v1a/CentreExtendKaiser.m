%====================================================
% CentreExtendKaiser Function
%====================================================

function [SCRPTipt,GAMFUNC,err] = CentreExtendKaiser(SCRPTipt,GAMFUNC)

err.flag = 0;

beta = str2double( SCRPTipt(strcmp('Beta',{SCRPTipt.labelstr})).entrystr);

GAMFUNC.GamFunc = @(r,p) (1/p^2)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2)); 

%figure(1); hold on;
%r = (0:0.001:1);
%p = 0.13;
%plot(r,GAMFUNC.GamFunc(r,p)*p);
%xlabel('Relative Radius');
%ylabel('Gamma Function');

error('not finished');

if strcmp(GAMFUNC.setup,'yes');
    return
end

GAMFUNC.GamShape = GAMFUNC.GamFunc(GAMFUNC.r,GAMFUNC.p);

