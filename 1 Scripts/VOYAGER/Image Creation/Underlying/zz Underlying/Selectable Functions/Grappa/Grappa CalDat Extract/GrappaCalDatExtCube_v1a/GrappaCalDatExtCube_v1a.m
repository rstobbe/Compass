%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GCDAT,err] = GrappaCalDatExtCube_v1a(SCRPTipt,GCDATipt)

Status2('busy','Extract Grappa Calibration Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GCDAT.method = GCDATipt.Func;
GCDAT.wid = str2double(GCDATipt.('Width'));

Status2('done','',2);
Status2('done','',3);







