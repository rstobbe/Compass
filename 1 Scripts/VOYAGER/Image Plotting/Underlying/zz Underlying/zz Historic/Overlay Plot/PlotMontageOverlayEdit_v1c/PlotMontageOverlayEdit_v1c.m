%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,PLOT,err] = PlotMontageOverlayEdit_v1c(SCRPTipt,PLOTipt)

Status2('busy','Montage Overlay Edit',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.intensity = PLOTipt.('Intensity');

Status2('done','',3);
