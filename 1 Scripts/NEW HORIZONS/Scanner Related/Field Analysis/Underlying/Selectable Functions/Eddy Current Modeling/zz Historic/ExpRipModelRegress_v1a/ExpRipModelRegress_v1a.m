%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,ECM,err] = EddyCurrentModel_v1a(SCRPTipt,ECMipt)

Status2('busy','Get Eddy Current Modeling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
ECM.method = ECMipt.Func;

Status2('done','',2);
Status2('done','',3);

