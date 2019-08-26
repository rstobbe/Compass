%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,B0MAP,err] = CreateB0Map_v1a(SCRPTipt,B0MAPipt)

Status2('done','B0 Map Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B0MAP.method = B0MAPipt.Func;
B0MAP.threshold = str2double(B0MAPipt.('Threshold'));
B0MAP.maxdisplay = str2double(B0MAPipt.('MaxDisp'));

Status2('done','',2);
Status2('done','',3);

