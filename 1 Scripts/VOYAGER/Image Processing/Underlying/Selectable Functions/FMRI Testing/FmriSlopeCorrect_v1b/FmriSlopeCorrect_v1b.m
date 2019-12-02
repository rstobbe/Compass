%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,PDGM,err] = FmriSlopeCorrect_v1b(SCRPTipt,PDGMipt)

Status2('busy','FMRI Slope',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PDGM.method = PDGMipt.Func;
PDGM.RelOffset = str2double(PDGMipt.('RelOffset'));
PDGM.RelSlope = str2double(PDGMipt.('RelSlope'));
PDGM.RefMean = str2double(PDGMipt.('RefMean'));

Status2('done','',2);
Status2('done','',3);
