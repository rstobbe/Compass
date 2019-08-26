%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,PLOT,err] = ShimPlot_v1a(SCRPTipt,PLOTipt)

Status2('busy','Plot Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;

Status2('done','',2);
Status2('done','',3);
