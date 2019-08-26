%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,PLOT,err] = Plot_SimYLim_v1a(SCRPTipt,PLOTipt)

Status2('busy','Plot Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.ylim = PLOTipt.('YLim');
PLOT.figsize = PLOTipt.('FigSize');

Status2('done','',2);
Status2('done','',3);