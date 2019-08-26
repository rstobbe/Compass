%====================================================
% (v1c)
%       - update for splitting
%====================================================

function [SCRPTipt,GAMFUNC,err] = GenHam_v1c(SCRPTipt,GAMFUNCipt)

Status2('busy','Get Info for Gamma Design Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
GAMFUNC.method = GAMFUNCipt.Func;
GAMFUNC.N = str2double(GAMFUNCipt.('GamEdgeVal'));

Status2('done','',2);
Status2('done','',3);



