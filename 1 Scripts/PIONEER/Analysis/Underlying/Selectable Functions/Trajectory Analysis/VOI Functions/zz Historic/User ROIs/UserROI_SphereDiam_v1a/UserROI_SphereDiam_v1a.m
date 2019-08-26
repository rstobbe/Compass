%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ROI,err] = UserROI_SphereDiam_v1a(SCRPTipt,ROIipt)

Status2('done','ROI Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROI.method = ROIipt.Func;
ROI.diam = str2double(ROIipt.('Diam'));

Status2('done','',2);
Status2('done','',3);

