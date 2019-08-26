%====================================================
% (v2e)
%       - update for split
%====================================================

function [SCRPTipt,PAD,err] = ProjAngleDist_TPI1_v2e(SCRPTipt,PADipt)

Status2('busy','Get Info For Projection Angle Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PAD.method = PADipt.Func;
PAD.Rnd = str2double(PADipt.('Randomizer'));

Status2('done','',2);
Status2('done','',3);