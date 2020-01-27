%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,ROIARR,err] = NoiseSdvThruDim_v1a(SCRPTipt,ROIARRipt)

Status2('busy','Roi Noise Through Dimension',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROIARR.method = ROIARRipt.Func;

Status2('done','',2);
Status2('done','',3);
