%===========================================
% 
%===========================================

function [SCRPTipt,STAB,err] = StabilityCheck_v1a(SCRPTipt,STABipt)

Status2('busy','Check Image Stability',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
STAB.method = STABipt.Func;
STAB.type = STABipt.('Type');
STAB.slice = str2double(STABipt.('SliceNum'));

Status2('done','',2);
Status2('done','',3);

