%=========================================================
% (v1b)
%       - switch magnitude polarity
%=========================================================

function [SCRPTipt,ATR,err] = AddDecayingExpTransResp_v1b(SCRPTipt,ATRipt)

Status2('busy','Get Eddy Current Modeling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
ATR.method = ATRipt.Func;
ATR.startfromzero = ATRipt.('StartFromZero');

Status2('done','',2);
Status2('done','',3);


