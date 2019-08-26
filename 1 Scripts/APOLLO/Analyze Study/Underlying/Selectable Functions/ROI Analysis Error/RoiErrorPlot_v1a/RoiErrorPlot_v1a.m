%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,ROIERR,err] = RoiErrorPlot_v1a(SCRPTipt,ROIERRipt)

Status2('busy','RoiErrorPlot',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROIERR.method = ROIERRipt.Func;

Status2('done','',2);
Status2('done','',3);
