%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,PDGM,err] = FmriSlope_v1a(SCRPTipt,PDGMipt)

Status2('busy','FMRI Slope',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PDGM.method = PDGMipt.Func;
PDGM.MinSigVal = str2double(PDGMipt.('MinSigVal'));

Status2('done','',2);
Status2('done','',3);

