%===========================================
% (v1c)
%    
%===========================================

function [SCRPTipt,MAP,err] = R2sMono2ImEst_v1c(SCRPTipt,MAPipt)

Status2('done','R2s MonoExp 2Image Estimate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MAP.method = MAPipt.Func;
MAP.maskval = str2double(MAPipt.('Mask'));
MAP.tediff = MAPipt.('TeDiff');

Status2('done','',2);
Status2('done','',3);
