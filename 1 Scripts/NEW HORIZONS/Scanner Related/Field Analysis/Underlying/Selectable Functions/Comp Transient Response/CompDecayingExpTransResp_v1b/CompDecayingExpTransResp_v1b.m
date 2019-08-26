%=========================================================
% (v1b)
%      
%=========================================================

function [SCRPTipt,CTR,err] = CompDecayingExpTransResp_v1b(SCRPTipt,CTRipt)

Status2('busy','Get Eddy Current Compensation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
CTR.method = CTRipt.Func;

Status2('done','',2);
Status2('done','',3);


