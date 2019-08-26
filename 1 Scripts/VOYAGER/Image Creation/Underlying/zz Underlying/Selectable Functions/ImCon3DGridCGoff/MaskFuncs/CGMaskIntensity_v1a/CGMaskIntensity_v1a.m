%=========================================================
% (v1a) 
% 
%=========================================================

function [SCRPTipt,MSK,err] = CGMaskIntensity_v1a(SCRPTipt,MSKipt)

Status2('busy','Get CG Start Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
MSK.method = MSKipt.Func;
MSK.relintensity = str2double(MSKipt.('RelIntensity'));
MSK.test = MSKipt.('Test');

Status2('done','',2);
Status2('done','',3);

