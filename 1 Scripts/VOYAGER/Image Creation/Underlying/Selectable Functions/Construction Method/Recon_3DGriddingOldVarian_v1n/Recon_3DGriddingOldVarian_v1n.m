%=========================================================
% (v1n) 
%     - from other v1n
%=========================================================

function [SCRPTipt,IC,err] = Recon_3DGriddingOldVarian_v1n(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;

Status2('done','',2);
Status2('done','',3);

