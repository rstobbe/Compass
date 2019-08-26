%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,PLOT,err] = Plot_ImpGradientsOrtho_v1c(SCRPTipt,PLOTipt)

Status2('busy','Plot Ortho Gradients',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.trajnum = str2double(PLOTipt.('TrajNum'));
PLOT.crop = PLOTipt.('Crop');

Status2('done','',2);
Status2('done','',3);

