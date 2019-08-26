%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,AVE,err] = AverageImages_v1a(SCRPTipt,AVEipt)

Status2('busy','Average Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
AVE.method = AVEipt.Func;

Status2('done','',2);
Status2('done','',3);

