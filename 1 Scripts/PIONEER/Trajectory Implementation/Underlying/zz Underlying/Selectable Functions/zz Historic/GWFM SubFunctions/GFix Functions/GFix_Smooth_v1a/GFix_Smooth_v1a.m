%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,GFIX,err] = GFix_Smooth_v1a(SCRPTipt,GFIXipt)

Status2('busy','Get GFix Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GFIX.method = GFIXipt.Func;
GFIX.smoothwin = str2double(GFIXipt.('SmoothWin'));

Status2('done','',2);
Status2('done','',3);