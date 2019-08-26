%==================================================
%  (v1c)
%       - alg start fixup   
%==================================================

function [SCRPTipt,CACCM,err] = CAccMeth3b_v1c(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACCM.method = CACCMipt.Func;   
CACCM.maxacc = str2double(CACCMipt.('MaxAcc'));
CACCM.maxjerk = str2double(CACCMipt.('MaxJrk'));
CACCM.acc0 = str2double(CACCMipt.('Acc0'));
CACCM.accramp = str2double(CACCMipt.('AccRamp'));

Status2('done','',3);