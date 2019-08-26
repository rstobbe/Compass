%====================================================
% (v1d)
%       - update for splitting
%====================================================

function [SCRPTipt,GAMFUNC,err] = Kaiser_v1d(SCRPTipt,GAMFUNCipt)

Status2('busy','Get Info for Kaiser Design Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
GAMFUNC.method = GAMFUNCipt.Func;
GAMFUNC.beta = str2double(GAMFUNCipt.('Beta'));

Status2('done','',2);
Status2('done','',3);
