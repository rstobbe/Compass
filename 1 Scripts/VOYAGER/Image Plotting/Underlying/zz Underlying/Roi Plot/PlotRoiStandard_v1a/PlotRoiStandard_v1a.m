%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,PLOTROI,err] = PlotRoiStandard_v1a(SCRPTipt,PLOTROIipt)

Status2('busy','Plot ROI',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOTROI.method = PLOTROIipt.Func;

Status2('done','',2);
Status2('done','',3);


