%====================================================
% (v1c)
%   - update projlen calc (include tolerance here)
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_YarnBallManual2_v1c(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;
DESOL.nin = str2double(DESOLipt.('Nin'));
DESOL.outshape = str2double(DESOLipt.('OutShape'));

Status2('done','',2);
Status2('done','',3);