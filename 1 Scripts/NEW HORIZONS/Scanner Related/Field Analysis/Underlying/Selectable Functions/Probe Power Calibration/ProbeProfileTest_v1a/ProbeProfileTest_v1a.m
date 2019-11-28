%====================================================
% (v1a) 
%       -
%====================================================

function [SCRPTipt,PPT,err] = ProbeProfileTest_v1a(SCRPTipt,PPTipt)

Status2('busy','Probe Profile Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PPT.method = PPTipt.Func;

Status2('done','',2);
Status2('done','',3);


