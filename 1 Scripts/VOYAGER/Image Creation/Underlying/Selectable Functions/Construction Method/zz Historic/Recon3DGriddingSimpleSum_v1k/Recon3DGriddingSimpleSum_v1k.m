%=========================================================
% (v1k) 
%     - input change 
%=========================================================

function [SCRPTipt,IC,err] = Recon3DGriddingSimpleSum_v1k(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.test = ICipt.('Test');
IC.visuals = ICipt.('Visuals');

Status2('done','',2);
Status2('done','',3);

