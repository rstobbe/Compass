%=========================================================
% (v1b)
%      - write SDC and Kx, Ky, Kz arrays (i.e. don't need to create later)
%      - save as singles
%=========================================================

function [SCRPTipt,RECONWRT,err] = WrtRecon_Basic_v1b(SCRPTipt,RECONWRTipt)

Status2('busy','Build Recon File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RECONWRT.method = RECONWRTipt.Func; 

Status2('done','',2);
Status2('done','',3);
