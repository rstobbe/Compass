%===========================================
% (v1b)
%    - refer to common routine
%===========================================

function [SCRPTipt,ROI,err] = FindMaxVOIforAverageIRS_v1b(SCRPTipt,ROIipt)

Status2('busy','Find ROI in Object',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROI.method = ROIipt.Func;
ROI.aveirs = str2double(ROIipt.('AverageIRS'));


Status2('done','',2);
Status2('done','',3);




