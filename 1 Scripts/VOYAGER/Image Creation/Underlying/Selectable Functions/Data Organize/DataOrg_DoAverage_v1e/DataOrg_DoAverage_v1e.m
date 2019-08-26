%=====================================================
% (v1e)
%      - Add Multi-Echo Capability
%=====================================================

function [SCRPTipt,DATORG,err] = DataOrg_AsIs_v1e(SCRPTipt,DATORGipt)

Status2('busy','Data Organization',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DATORG.method = DATORGipt.Func;

Status2('done','',2);
Status2('done','',3);









