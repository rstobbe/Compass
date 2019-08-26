%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ROI,err] = AutoROI_SphereDiam_v1a(SCRPTipt,ROIipt)

Status2('done','ROI Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROI.method = ROIipt.Func;

Status2('done','',2);
Status2('done','',3);

