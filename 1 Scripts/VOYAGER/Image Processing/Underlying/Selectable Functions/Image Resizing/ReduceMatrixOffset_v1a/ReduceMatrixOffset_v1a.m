%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,RESZ,err] = ReduceMatrixOffset_v1a(SCRPTipt,RESZipt)

Status2('busy','Reduce Image Matrix',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
RESZ.method = RESZipt.Func;
RESZ.newsize = RESZipt.('NewSize');
RESZ.offset = RESZipt.('Offset');

Status2('done','',2);
Status2('done','',3);

