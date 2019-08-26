%=========================================================
% (v1d)
%     - Include hack for elip not on 'z'
%     - Prisma sequence should be updated
%=========================================================

function [SCRPTipt,PRMWRT,err] = WrtParam_SiemensYarnBall_v1d(SCRPTipt,PRMWRTipt)

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


