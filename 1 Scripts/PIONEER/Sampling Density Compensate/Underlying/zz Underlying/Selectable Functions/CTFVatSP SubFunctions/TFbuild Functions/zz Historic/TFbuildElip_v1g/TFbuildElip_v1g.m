%================================================================================
% (v1h)
%       - MinSubSamp instead of MaxSubSamp
%================================================================================

function [SCRPTipt,TFB,err] = TFbuildElip_v1g(SCRPTipt,TFBipt)

Status2('done','Get Build TF Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
TFB.MinRadDim = str2double(TFBipt.('MinRadDim'));
TFB.MinSubSamp = str2double(TFBipt.('MinSubSamp'));

Status2('done','',2);
Status2('done','',3);