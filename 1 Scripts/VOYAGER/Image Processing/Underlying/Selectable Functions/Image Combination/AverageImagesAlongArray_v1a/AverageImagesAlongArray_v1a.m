%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,AVE,err] = AverageImagesAlongArray_v1a(SCRPTipt,AVEipt)

Status2('busy','Average Images Along Array',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
AVE.method = AVEipt.Func;
AVE.dim = str2double(AVEipt.Dimension);

Status2('done','',2);
Status2('done','',3);

