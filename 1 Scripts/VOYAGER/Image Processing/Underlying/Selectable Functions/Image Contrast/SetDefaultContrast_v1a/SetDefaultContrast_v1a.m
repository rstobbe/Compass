%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,CTRST,err] = SetDefaultContrast_v1a(SCRPTipt,CTRSTipt)

Status2('done','Set Default Contrast',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CTRST.method = CTRSTipt.Func;
CTRST.min = str2double(CTRSTipt.('Min'));
CTRST.max = str2double(CTRSTipt.('Max'));
CTRST.colour = CTRSTipt.('Colour');
CTRST.type = CTRSTipt.('Type');

Status2('done','',2);
Status2('done','',3);