%====================================================
% (v3d) 
%       - as PosBgrndSmooth_v3d (hard coded values)
%====================================================

function [SCRPTipt,POSBG,err] = PosBgrndMRS47_v3d(SCRPTipt,POSBGipt)

Status2('busy','Get Info for Postition and Background Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.plstart = 0.2;
POSBG.plstop = 1;
POSBG.bgstart = 2;
POSBG.bgstop = 15;
POSBG.smoothfraction = 1;
POSBG.smoothfactor = 0.0001;                % i.e. no smoothing

Status2('done','',2);
Status2('done','',3);


