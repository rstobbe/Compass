%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,TF,err] = TF_YarnBall_v1a(SCRPTipt,TFipt)

Status2('done','Get TF Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TF.script = TFipt.Func;
TF.beta = str2double(TFipt.('Beta'));
TF.enddrop = str2double(TFipt.('EndDrop'));

Status2('done','',2);
Status2('done','',3);