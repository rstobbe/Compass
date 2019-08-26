%=====================================================
% (v1g)
%       - start DCcorPA_TrlFid_v1g 
%=====================================================

function [SCRPTipt,DCCOR,err] = DCcorSpiral_TrlFid_v1g(SCRPTipt,DCCORipt)

Status2('busy','DC correct FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DCCOR.method = DCCORipt.Func;
DCCOR.trfidper = str2double(DCCORipt.('TrlFid'));

Status2('done','',2);
Status2('done','',3);







