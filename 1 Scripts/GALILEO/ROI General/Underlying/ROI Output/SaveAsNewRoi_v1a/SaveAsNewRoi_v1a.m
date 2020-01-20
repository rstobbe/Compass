%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,SAVE,err] = SaveAsNewRoi_v1a(SCRPTipt,SAVEipt)

Status2('busy','ROI Saving',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
SAVE.method = SAVEipt.Func;

Status2('done','',2);
Status2('done','',3);

