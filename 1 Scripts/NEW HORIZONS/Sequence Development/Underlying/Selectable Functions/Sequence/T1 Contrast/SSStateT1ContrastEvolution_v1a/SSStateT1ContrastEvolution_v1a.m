%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TST,err] = SSStateT1ContrastEvolution_v1a(SCRPTipt,TSTipt)

Status2('busy','Spoiled Steady State T1 Contrast',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;
TST.TR = str2double(TSTipt.('TR'));
TST.Flip = str2double(TSTipt.('Flip'));


Status2('done','',2);
Status2('done','',3);
