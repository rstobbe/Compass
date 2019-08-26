%=========================================================
% (v1b)
%       - Move majority of function to 'shared'
%=========================================================

function [SCRPTipt,PLOT,err] = PlotMontageStandard_v1b(SCRPTipt,PLOTipt)

Status2('busy','Plot Image Montage',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.colour = PLOTipt.('Colour');

Status2('done','',2);
Status2('done','',3);


