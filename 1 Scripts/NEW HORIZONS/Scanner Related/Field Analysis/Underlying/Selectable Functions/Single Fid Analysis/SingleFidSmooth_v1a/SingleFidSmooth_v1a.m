%====================================================
% (v1a) 
%       -
%====================================================

function [SCRPTipt,POSBG,err] = SingleFidSmooth_v1a(SCRPTipt,POSBGipt)

Status2('busy','Single Fid Analysis',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.smoothfactor = str2double(POSBGipt.SmoothFactor);
POSBG.smoothfraction = str2double(POSBGipt.SmoothFraction);

Status2('done','',2);
Status2('done','',3);


