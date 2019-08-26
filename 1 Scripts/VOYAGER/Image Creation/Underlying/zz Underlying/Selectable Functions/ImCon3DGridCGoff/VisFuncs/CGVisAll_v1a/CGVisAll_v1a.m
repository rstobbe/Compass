%=========================================================
% (v1a) 
%  
%=========================================================

function [SCRPTipt,VIS,err] = CGVisAll_v1a(SCRPTipt,VISipt)

Status2('busy','Get CG Visualization Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
VIS.method = VISipt.Func;

Status2('done','',2);
Status2('done','',3);


