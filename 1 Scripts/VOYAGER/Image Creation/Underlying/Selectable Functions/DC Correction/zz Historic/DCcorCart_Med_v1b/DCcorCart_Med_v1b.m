%=====================================================
% (v1b)
%       Make All Input/Output 5 Dims.
%=====================================================

function [SCRPTipt,DCCOR,err] = DCcorCart_Med_v1b(SCRPTipt,DCCORipt)

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







