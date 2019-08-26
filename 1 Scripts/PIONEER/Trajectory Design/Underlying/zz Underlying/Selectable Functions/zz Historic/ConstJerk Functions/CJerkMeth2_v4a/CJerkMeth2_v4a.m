%==================================================
%  (v4a)
%     - 4 exponentials
%==================================================

function [SCRPTipt,CACCJ,err] = CJerkMeth2_v4a(SCRPTipt,CACCJipt)

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
CACCJ.exptc4 = str2double(CACCJipt.('ExpTc4'));
CACCJ.expval4 = str2double(CACCJipt.('ExpRelVal4')); 


Status2('done','',3);