%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,COR,err] = B1corrDW_v1b(SCRPTipt,CORipt)

Status2('done','B1 Correct (Density Weighted)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
COR.method = CORipt.Func;

Status2('done','',2);
Status2('done','',3);