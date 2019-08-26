%=====================================================
% (v1b)
%       - Update for function splitting
%=====================================================

function [SCRPTipt,DCCOR,err] = DCcor_trfid_v1b(SCRPTipt,DCCORipt)

Status2('busy','DC correct FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DCCOR.method = DCCORipt.Func;
DCCOR.trfidper = str2double(DCCORipt.('trfid'));

Status2('done','',2);
Status2('done','',3);







