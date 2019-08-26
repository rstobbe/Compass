%=========================================================
% (v1a) 
% 
%=========================================================

function [SCRPTipt,MSK,err] = CGMaskNone_v1a(SCRPTipt,MSKipt)

Status2('busy','Get CG Mask Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
MSK.method = MSKipt.Func;

Status2('done','',2);
Status2('done','',3);

