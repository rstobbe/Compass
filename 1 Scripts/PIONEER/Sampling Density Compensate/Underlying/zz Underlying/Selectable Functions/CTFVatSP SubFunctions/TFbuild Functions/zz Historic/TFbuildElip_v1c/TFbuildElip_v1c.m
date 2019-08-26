%================================================================================
% (v1c)
%       - update for function splitting
%================================================================================

function [SCRPTipt,TFB,err] = TFbuildElip_v1c(SCRPTipt,TFBipt)

Status2('done','Get Build TF Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
TFB.MinRadDim = str2double(TFBipt.('MinRadDim'));
TFB.MaxSubSamp = str2double(TFBipt.('MaxSubSamp'));

Status2('done','',2);
Status2('done','',3);