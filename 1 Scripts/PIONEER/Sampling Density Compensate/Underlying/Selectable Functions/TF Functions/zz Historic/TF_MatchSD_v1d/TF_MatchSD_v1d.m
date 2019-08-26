%=========================================================
% (v1d) 
%       - split 
%=========================================================

function [SCRPTipt,TF,err] = TF_MatchSD_v1d(SCRPTipt,TFipt)

Status2('done','Get TF Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TF.script = TFipt.Func;

Status2('done','',2);
Status2('done','',3);