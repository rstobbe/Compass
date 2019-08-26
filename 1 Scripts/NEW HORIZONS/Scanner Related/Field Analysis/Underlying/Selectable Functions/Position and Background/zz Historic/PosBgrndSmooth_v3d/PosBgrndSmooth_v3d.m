%====================================================
% (v3d) 
%       - update smoothing
%====================================================

function [SCRPTipt,POSBG,err] = PosBgrndSmooth_v3d(SCRPTipt,POSBGipt)

Status2('busy','Get Info for Postition and Background Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.plstart = str2double(POSBGipt.PLstart);
POSBG.plstop = str2double(POSBGipt.PLstop);
POSBG.bgstart = str2double(POSBGipt.BGstart);
POSBG.bgstop = str2double(POSBGipt.BGstop);
POSBG.smoothfactor = str2double(POSBGipt.SmoothFactor);
POSBG.smoothfraction = str2double(POSBGipt.SmoothFraction);

Status2('done','',2);
Status2('done','',3);


