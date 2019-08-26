%==================================================
%  (v2b)
%     - 2 exponentials
%==================================================

function [SCRPTipt,CACCJ,err] = CJerkMeth2_v2b(SCRPTipt,CACCJipt)

Status2('done','Get Jerk Constraint info',3);

err.flag = 0;
err.msg = '';

CACCJ.method = CACCJipt.Func;   
CACCJ.exptc1 = str2double(CACCJipt.('Jrk_tc1'));
CACCJ.expval1 = str2double(CACCJipt.('Jrk_val1')); 
CACCJ.exptc2 = str2double(CACCJipt.('Jrk_tc2'));
CACCJ.expval2 = str2double(CACCJipt.('Jrk_val2')); 

Status2('done','',3);