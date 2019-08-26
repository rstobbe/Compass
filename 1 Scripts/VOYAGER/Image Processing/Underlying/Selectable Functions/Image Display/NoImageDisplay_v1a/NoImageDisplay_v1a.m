%=========================================================
% (v1a)
%      -
%=========================================================

function [SCRPTipt,SCRPTGBL,DISP,err] = NoImageDisplay_v1a(SCRPTipt,SCRPTGBL,DISPipt)

Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;

Status2('done','',2);
Status2('done','',3);
