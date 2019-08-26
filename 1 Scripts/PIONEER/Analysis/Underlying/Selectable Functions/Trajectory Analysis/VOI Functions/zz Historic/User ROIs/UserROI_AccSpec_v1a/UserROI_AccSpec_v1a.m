%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ROI,err] = UserROI_AccSpec_v1a(SCRPTipt,ROIipt)

Status2('done','ROI Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROI.method = ROIipt.Func;
ROI.acc = str2double(ROIipt.('Acc'));

Status2('done','',2);
Status2('done','',3);





