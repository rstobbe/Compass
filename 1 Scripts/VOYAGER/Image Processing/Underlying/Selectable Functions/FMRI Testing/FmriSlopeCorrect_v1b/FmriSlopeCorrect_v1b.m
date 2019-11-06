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
PDGM.MinSigVal = str2double(PDGMipt.('MinSigVal'));
PDGM.Significance = str2double(PDGMipt.('Significance'));
PDGM.Data = PDGMipt.('Data');

Status2('done','',2);
Status2('done','',3);

