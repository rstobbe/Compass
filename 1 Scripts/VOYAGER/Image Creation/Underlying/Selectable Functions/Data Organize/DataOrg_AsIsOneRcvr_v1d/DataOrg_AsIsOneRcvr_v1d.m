%=====================================================
% (v1d)
%      - Move averages below
%=====================================================

function [SCRPTipt,DATORG,err] = DataOrg_AsIsOneRcvr_v1d(SCRPTipt,DATORGipt)

Status2('busy','Data Organization',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DATORG.method = DATORGipt.Func;
DATORG.rcvrnum = str2double(DATORGipt.('RcvrNumber'));

Status2('done','',2);
Status2('done','',3);









