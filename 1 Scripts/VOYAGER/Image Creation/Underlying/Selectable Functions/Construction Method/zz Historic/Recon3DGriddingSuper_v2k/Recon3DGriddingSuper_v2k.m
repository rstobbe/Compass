%=========================================================
% (v2k) 
%     - same as 1k (function identical) - no input options
%=========================================================

function [SCRPTipt,IC,err] = Recon3DGriddingSuper_v2k(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.test = 'None';
IC.visuals = 'No';
IC.profres = 10;
IC.proffilt = 12;

Status2('done','',2);
Status2('done','',3);

