%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,CALC,err] = AccCalc_FixedROISphereDiam_v1a(SCRPTipt,CALCipt)

Status2('done','Calc Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
CALC.method = CALCipt.Func;
CALC.diam = str2double(CALCipt.('Diam'));


Status2('done','',2);
Status2('done','',3);




