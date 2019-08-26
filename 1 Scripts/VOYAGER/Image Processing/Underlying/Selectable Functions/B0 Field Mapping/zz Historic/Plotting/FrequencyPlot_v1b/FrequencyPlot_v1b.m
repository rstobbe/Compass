%=========================================================
% (v1b)
%       - Same as ShimPlot_v1b
%=========================================================

function [SCRPTipt,PLOT,err] = FrequencyPlot_v1b(SCRPTipt,PLOTipt)

Status2('busy','Plot Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.intensity = PLOTipt.('Intensity');

Status2('done','',2);
Status2('done','',3);
