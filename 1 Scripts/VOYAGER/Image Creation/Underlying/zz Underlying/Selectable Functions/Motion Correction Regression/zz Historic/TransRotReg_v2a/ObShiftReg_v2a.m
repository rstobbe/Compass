%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,OBSHFTREG,err] = ObShiftReg_v2a(SCRPTipt,OBSHFTREGipt)

Status2('busy','Get Object Shift Regression Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
OBSHFTREG.method = OBSHFTREGipt.Func;

Status2('done','',2);
Status2('done','',3);

