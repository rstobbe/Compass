%=========================================================
% (v1b)
%     - include option to exit just with name
%=========================================================

function [SCRPTipt,PRMWRT,err] = WrtParam_SiemensYarnBall_v1b(SCRPTipt,PRMWRTipt)

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


