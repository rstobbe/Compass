%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ImportFID_VarianPA_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Load FID');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

FIDpath = SCRPTGBL.FID.path;

%---------------------------------------------
% Load FID
%---------------------------------------------
[FIDmat] = ImportExpArrayFIDmatV_v1a([FIDpath,'\fid']);

%---------------------------------------------
% Returned
%---------------------------------------------
SCRPTGBL.Image = FIDmat;

%--------------------------------------------
% Output
%--------------------------------------------
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

Status('done','');
