%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,ROIARR,err] = AveNoiseThruDim_v1a(SCRPTipt,ROIARRipt)

Status2('busy','Roi Noise Through Dimension',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROIARR.method = ROIARRipt.Func;
ROIARR.distribution = ROIARRipt.('Distribution');

Status2('done','',2);
Status2('done','',3);
