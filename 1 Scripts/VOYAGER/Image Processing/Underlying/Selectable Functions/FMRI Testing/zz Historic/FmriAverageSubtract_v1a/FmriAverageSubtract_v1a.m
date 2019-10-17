%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,AVE,err] = FmriAverageSubtract_v1a(SCRPTipt,AVEipt)

Status2('busy','FMRI Average and Subtract',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
AVE.method = AVEipt.Func;

Status2('done','',2);
Status2('done','',3);

