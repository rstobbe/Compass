%=========================================================
% (v1b)
%      - update includes mask as an input
%=========================================================

function [SCRPTipt,ALGN,err] = AlignImages_v1b(SCRPTipt,ALGNipt)

Status2('busy','Align Images Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;
ALGN.maskthresh = str2double(ALGNipt.('MaskThresh'));

Status2('done','',2);
Status2('done','',3);

