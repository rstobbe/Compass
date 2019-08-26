%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,PLOT,err] = Plot_ImpkSpace3DMultiEchoSelect_v1d(SCRPTipt,PLOTipt)

Status2('busy','Plot kSpace3D',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.trajnum = str2double(PLOTipt.('TrajNum'));
PLOT.echonum = str2double(PLOTipt.('EchoNum'));

Status2('done','',2);
Status2('done','',3);

