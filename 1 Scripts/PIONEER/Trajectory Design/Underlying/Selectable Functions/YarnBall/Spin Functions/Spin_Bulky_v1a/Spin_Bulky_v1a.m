%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Bulky_v1a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.ForceOddSpokes = SPINipt.('ForceOddSpokes');
SPIN.AziSampSpin = str2double(SPINipt.('AziSampSpin'));
SPIN.PolSampSpin = str2double(SPINipt.('PolSampSpin'));
SPIN.AziSampTraj = str2double(SPINipt.('AziSampTraj'));
SPIN.PolSampTraj = str2double(SPINipt.('PolSampTraj'));

Status2('done','',2);
Status2('done','',3);
