%=========================================================
% (v2a)
%     
%=========================================================

function [SCRPTipt,PLOT,err] = PlotMontageCompass_v2a(SCRPTipt,PLOTipt)

Status2('busy','Plot Image Montage',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;

Status2('done','',2);
Status2('done','',3);


