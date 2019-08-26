%=========================================================
% (v2m) 
%     - add in echos loop
%=========================================================

function [SCRPTipt,RECON,err] = Recon_3DGriddingSuperDefault_v2m(SCRPTipt,RECONipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
RECON.method = RECONipt.Func;
RECON.test = 'None';
RECON.visuals = 'SingleIm';
RECON.profres = 10;
RECON.proffilt = 12;

Status2('done','',2);
Status2('done','',3);

