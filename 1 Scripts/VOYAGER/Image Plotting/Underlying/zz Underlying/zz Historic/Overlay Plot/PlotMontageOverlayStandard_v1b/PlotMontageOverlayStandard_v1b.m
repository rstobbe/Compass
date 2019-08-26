%=========================================================
% (v1b)
%       - Move majority of function to 'shared'
%=========================================================

function [SCRPTipt,PLOT,err] = PlotMontageOverlayStandard_v1b(SCRPTipt,PLOTipt)

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
