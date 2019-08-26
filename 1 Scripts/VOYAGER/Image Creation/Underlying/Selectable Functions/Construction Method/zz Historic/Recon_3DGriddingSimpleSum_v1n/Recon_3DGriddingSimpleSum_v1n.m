%=========================================================
% (v1n) 
%     - start 'Recon_3DGriddingReturnAll_v1n'
%=========================================================

function [SCRPTipt,IC,err] = Recon_3DGriddingSimpleSum_v1n(SCRPTipt,ICipt)

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

