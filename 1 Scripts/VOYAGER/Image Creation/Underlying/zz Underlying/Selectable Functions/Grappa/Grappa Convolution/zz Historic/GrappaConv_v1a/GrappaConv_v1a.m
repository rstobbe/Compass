%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GCONV,err] = GrappaConv_v1a(SCRPTipt,GCONVipt)

Status2('busy','Grappa Recon',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GCONV.method = GCONVipt.Func;

Status2('done','',2);
Status2('done','',3);







