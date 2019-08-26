%===========================================
% (v1b)
%    - just naming update
%===========================================

function [SCRPTipt,ROIMAN,err] = DropEdgesVOI_v1b(SCRPTipt,ROIMANipt)

Status2('done','ROIMAN Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ROIMAN.method = ROIMANipt.Func;
ROIMAN.minirs = str2double(ROIMANipt.('MinIRS'));

Status2('done','',2);
Status2('done','',3);




