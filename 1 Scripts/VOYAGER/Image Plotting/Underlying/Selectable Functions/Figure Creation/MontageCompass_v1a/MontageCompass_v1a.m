%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,MONT,err] = MontageCompass_v1a(SCRPTipt,SCRPTGBL,MONTipt)

Status2('busy','Create Montage for Compass',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MONT.method = MONTipt.Func; 

Status2('done','',2);
Status2('done','',3);
