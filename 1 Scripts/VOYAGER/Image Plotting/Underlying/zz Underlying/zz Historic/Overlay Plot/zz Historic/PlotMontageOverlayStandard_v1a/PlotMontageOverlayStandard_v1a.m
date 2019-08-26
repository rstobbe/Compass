%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,PLOT,err] = MontageOverlayStandard_v1a(SCRPTipt,PLOTipt)

Status2('busy','Montage Overlay Standard',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;

Status2('done','',2);
Status2('done','',3);
