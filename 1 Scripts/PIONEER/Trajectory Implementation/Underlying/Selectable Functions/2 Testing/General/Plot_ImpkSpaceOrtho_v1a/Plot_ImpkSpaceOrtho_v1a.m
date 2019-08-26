%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,PLOT,err] = Plot_ImpkSpaceOrtho_v1a(SCRPTipt,PLOTipt)

Status2('busy','Plot k-Space (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.trajnum = str2double(PLOTipt.('TrajNum'));

Status2('done','',2);
Status2('done','',3);

