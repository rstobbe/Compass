%====================================================
% (v1d)
%   - as TpiManual (no plotting / hardcode values)
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_TpiQuickTest_v1d(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;
DESOL.fine = 50;
DESOL.shape = 10;

Status2('done','',2);
Status2('done','',3);