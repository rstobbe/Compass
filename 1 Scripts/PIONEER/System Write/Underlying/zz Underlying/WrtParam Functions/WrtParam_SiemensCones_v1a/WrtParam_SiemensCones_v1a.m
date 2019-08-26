%=========================================================
% (v1a)
%     - 
%=========================================================

function [SCRPTipt,PRMWRT,err] = WrtParam_SiemensRadial3D_v1a(SCRPTipt,PRMWRTipt)

Status2('busy','Write Parameters for Siemens Radial3D',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
PRMWRT.method = PRMWRTipt.Func;

Status2('done','',2);
Status2('done','',3);


