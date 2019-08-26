%=====================================================
% (v1c)
%       Include 3D DCcor each readout
%=====================================================

function [SCRPTipt,DCCOR,err] = DCcorCart_Med_v1c(SCRPTipt,DCCORipt)

Status2('busy','DC correct FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DCCOR.method = DCCORipt.Func;

Status2('done','',2);
Status2('done','',3);







