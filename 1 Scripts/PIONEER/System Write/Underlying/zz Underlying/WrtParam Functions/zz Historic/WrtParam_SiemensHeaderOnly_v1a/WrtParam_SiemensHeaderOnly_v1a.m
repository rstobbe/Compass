%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,PRMWRT,err] = WrtParam_SiemensHeaderOnly_v1a(SCRPTipt,PRMWRTipt)

Status2('busy','Write Siemens Header Only',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PRMWRT.method = PRMWRTipt.Func;


