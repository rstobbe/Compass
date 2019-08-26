%=========================================================
% (v1e) 
%       - As TF_MatchSD_v1e
%=========================================================

function [SCRPTipt,TF,err] = TF_MatchSampdensPlank_v1e(SCRPTipt,TFipt)

Status2('done','Get TF Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TF.script = TFipt.Func;
TF.enddrop = str2double(TFipt.('EndDrop'));

Status2('done','',2);
Status2('done','',3);