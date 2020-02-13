%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,EDIT,err] = CombineRois_v1a(SCRPTipt,SCRPTGBL,EDITipt)

Status2('busy','Combine ROIs',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EDIT.method = EDITipt.Func;

Status2('done','',2);
Status2('done','',3);


