%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,FILT,err] = FilterImageKaiser3D_v1a(SCRPTipt,FILTipt)

Status2('done','Filter Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FILT.method = FILTipt.Func;
FILT.beta = str2double(FILTipt.('beta'));

Status2('done','',2);
Status2('done','',3);

