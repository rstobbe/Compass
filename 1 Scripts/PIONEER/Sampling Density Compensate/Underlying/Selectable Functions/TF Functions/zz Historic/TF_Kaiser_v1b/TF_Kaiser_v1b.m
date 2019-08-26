%=========================================================
% (v1b) 
%       - update for RWSUI_BA 
%=========================================================

function [SCRPTipt,TF,err] = TF_Kaiser_v1b(SCRPTipt,TFipt)

Status2('done','Get TF Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TF.script = TFipt.Func;
TF.beta = str2double(TFipt.('Beta'));

Status2('done','',2);
Status2('done','',3);