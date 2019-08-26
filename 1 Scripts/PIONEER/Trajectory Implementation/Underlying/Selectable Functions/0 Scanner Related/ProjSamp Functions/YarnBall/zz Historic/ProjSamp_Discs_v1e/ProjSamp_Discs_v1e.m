%====================================================
% (v1e)
%       - Use ndiscs & nspokes from input struct (SPIN)
%====================================================


function [SCRPTipt,PSMP,err] = ProjSamp_Discs_v1e(SCRPTipt,PSMPipt) 

Status2('done','Get Projection Sampling Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSMP.method = PSMPipt.Func;

Status2('done','',2);
Status2('done','',3);










