%=====================================================
% (v1c)
%      
%=====================================================

function [SCRPTipt,DATORG,err] = DataOrg_LowAsIs_v1a(SCRPTipt,DATORGipt)

Status2('busy','Data Organization',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DATORG.method = DATORGipt.Func;
DATORG.kmaxrel = str2double(DATORGipt.('kmaxRel'));

Status2('done','',2);
Status2('done','',3);









