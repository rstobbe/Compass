%===========================================
% (v1b)
%       - expand FoV before filter (avoid wrapping)
%===========================================

function [SCRPTipt,FILT,err] = LowPassFilterKaiser3D_v1b(SCRPTipt,FILTipt)

Status2('done','Filter Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FILT.method = FILTipt.Func;
FILT.kmax = str2double(FILTipt.('kmax'));
FILT.beta = str2double(FILTipt.('beta'));

Status2('done','',2);
Status2('done','',3);

