%==================================================
%  (v1b)
%     
%==================================================

function [SCRPTipt,CACCJ,err] = CJerkMeth2_v1b(SCRPTipt,CACCJipt)

Status2('done','Get Jerk Constraint info',3);

err.flag = 0;
err.msg = '';

CACCJ.method = CACCJipt.Func;   
CACCJ.exptc = str2double(CACCJipt.('Jrk_tc'));
CACCJ.expval = str2double(CACCJipt.('Jrk_val')); 

Status2('done','',3);