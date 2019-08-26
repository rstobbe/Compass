%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,SYSWRT,err] = SysWrt_DummyYarnBall_v1a(SCRPTipt,SYSWRTipt)

Status2('busy','Dummy Write',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT.method = SYSWRTipt.Func; 
SYSWRT.dummies = str2double(SYSWRTipt.('Dummies')); 

Status2('done','',2);
Status2('done','',3);
