%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,PLOT,err] = PlotMontageOverlayEdit_v1a(SCRPTipt,PLOTipt)

Status2('busy','Montage Overlay Edit',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.ncolumns = str2double(PLOTipt.('nColumns'));
PLOT.imsize = PLOTipt.('ImSize');
PLOT.slclbl = PLOTipt.('SliceLabel');
PLOT.intensity = PLOTipt.('Intensity');
PLOT.figno = PLOTipt.('Figno');

Status2('done','',2);
Status2('done','',3);
