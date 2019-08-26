%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,SCALE,err] = ImScalePsf_v1a(SCRPTipt,ORNTipt)

Status2('busy','Get Scale Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SCALE.method = ORNTipt.Func;

Status2('done','',2);
Status2('done','',3);









