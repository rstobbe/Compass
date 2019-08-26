%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ROIMAN,err] = ManipROI_DropEdges_v1a(SCRPTipt,ROIMANipt)

Status2('done','ROIMAN Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROIMAN.method = ROIMANipt.Func;
ROIMAN.minpsfa = str2double(ROIMANipt.('MinPSFA'));

Status2('done','',2);
Status2('done','',3);




