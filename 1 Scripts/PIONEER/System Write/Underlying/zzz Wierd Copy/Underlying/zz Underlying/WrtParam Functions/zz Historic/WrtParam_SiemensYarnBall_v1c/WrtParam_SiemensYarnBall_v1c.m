%=========================================================
% (v1c)
%     - test to make sure elip on 'z' (in YarnBall space)
%     - suggest ID from IMP
%=========================================================

function [SCRPTipt,PRMWRT,err] = WrtParam_SiemensYarnBall_v1c(SCRPTipt,PRMWRTipt)

Status2('busy','Write Parameters for Siemens YarnBall',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PRMWRT.method = PRMWRTipt.Func;

Status2('done','',2);
Status2('done','',3);


