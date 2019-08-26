%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,PLOT,err] = Plot_StdTPIGradientsOrtho_v1a(SCRPTipt,PLOTipt)

Status2('busy','Plot Standard TPI Gradients (Ortho)',2);
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

