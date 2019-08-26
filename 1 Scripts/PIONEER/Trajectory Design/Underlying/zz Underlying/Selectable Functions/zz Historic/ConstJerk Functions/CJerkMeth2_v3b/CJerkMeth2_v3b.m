%==================================================
%  (v3b)
%     - change so Val = 0 gives 0
%==================================================

function [SCRPTipt,CACCJ,err] = CJerkMeth2_v3b(SCRPTipt,CACCJipt)

Status2('done','Get Jerk Constraint info',3);

err.flag = 0;
err.msg = '';

CACCJ.method = CACCJipt.Func;   
CACCJ.exptc1 = str2double(CACCJipt.('ExpTc1'));
CACCJ.expval1 = str2double(CACCJipt.('ExpRelVal1')); 
CACCJ.exptc2 = str2double(CACCJipt.('ExpTc2'));
CACCJ.expval2 = str2double(CACCJipt.('ExpRelVal2')); 
CACCJ.exptc3 = str2double(CACCJipt.('ExpTc3'));
CACCJ.expval3 = str2double(CACCJipt.('ExpRelVal3')); 

Status2('done','',3);