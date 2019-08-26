%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_Cones_v1a(SCRPTipt,DESMETHipt)

Status('busy','Create Cones Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;

Status2('done','',2);
Status2('done','',3);

