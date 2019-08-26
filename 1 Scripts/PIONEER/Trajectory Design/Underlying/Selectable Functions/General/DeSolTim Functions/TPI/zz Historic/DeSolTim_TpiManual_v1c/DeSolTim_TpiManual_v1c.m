%====================================================
% (v1c)
%   - 
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_TpiManual_v1c(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;
DESOL.nin = str2double(DESOLipt.('Nin'));
DESOL.nout = str2double(DESOLipt.('Nout'));
DESOL.trans = str2double(DESOLipt.('TransPrm'));

Status2('done','',2);
Status2('done','',3);