%====================================================
% Uniform
%====================================================

function [SCRPTipt,GAMFUNC,err] = Uniform(SCRPTipt,GAMFUNC)

err.flag = 0;

GAMFUNC.GamFunc = @(r,p) (1/p^2); 

if strcmp(GAMFUNC.setup,'yes');
    return
end
GAMFUNC.GamShape = (1/GAMFUNC.p^2)*ones(size(GAMFUNC.r));