%=========================================================
% (v1a)
%       - 
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFIDSim_PointSpreadFunc_v1a(SCRPTipt,SCRPTGBL,FIDipt,RWSUI)

Status2('busy','Load Simulation Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.DatName = 'PSF';

Status2('done','',2);
Status2('done','',3);

