%=========================================================
% (v1a)
%       - 
%=========================================================

function [SCRPTipt,FID,err] = ImportFIDSim_3DCartMat_v1a(SCRPTipt,FIDipt)

Status2('busy','Load Simulation Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;

Status2('done','',2);
Status2('done','',3);




