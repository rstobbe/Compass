%==================================================
% (v1a)
%       - CACC back into DesType for mod
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_Radial3D_v1a(SCRPTipt,DESMETHipt)

Status('busy','Create Radial3D Design');
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

