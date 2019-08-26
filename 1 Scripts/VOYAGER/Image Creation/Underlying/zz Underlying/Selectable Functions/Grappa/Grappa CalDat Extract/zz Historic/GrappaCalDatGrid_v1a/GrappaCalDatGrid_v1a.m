%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GCDAT,err] = GrappaCalDatGrid_v1a(SCRPTipt,GCDATipt)

Status2('busy','Get Grappa Calibration Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GCDAT.method = GCDATipt.Func;

Status2('done','',2);
Status2('done','',3);







