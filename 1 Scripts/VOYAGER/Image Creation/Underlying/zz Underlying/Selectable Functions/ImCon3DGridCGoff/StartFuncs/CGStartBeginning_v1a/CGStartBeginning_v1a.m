%=========================================================
% (v1a) 
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,STRT,err] = CGStartBeginning_v1a(SCRPTipt,SCRPTGBL,STRTipt)

Status2('busy','Get CG Start Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
STRT.method = STRTipt.Func;

Status2('done','',2);
Status2('done','',3);

