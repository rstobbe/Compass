%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GKERN,err] = GrappaKernCube_v1a(SCRPTipt,GKERNipt)

Status2('busy','Create Grappa Kernel',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GKERN.method = GKERNipt.Func;
GKERN.wid = str2double(GKERNipt.('Width'));

Status2('done','',2);
Status2('done','',3);







