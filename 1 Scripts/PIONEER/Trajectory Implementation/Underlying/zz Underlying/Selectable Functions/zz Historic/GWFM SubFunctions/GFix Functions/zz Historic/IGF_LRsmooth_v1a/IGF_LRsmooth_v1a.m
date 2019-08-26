%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,IGF,err] = IGF_LRsmooth_v1a(SCRPTipt,IGFipt)

Status2('busy','Get IGF Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IGF.method = IGFipt.Func;
IGF.smoothwin = str2double(IGFipt.('SmoothWin'));

Status2('done','',2);
Status2('done','',3);