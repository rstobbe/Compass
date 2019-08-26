%=========================================================
% (v1c) 
%       - start 'TF_Kaiser_v1c'
%=========================================================

function [SCRPTipt,TF,err] = TF_KaiserRoot_v1c(SCRPTipt,TFipt)

Status2('done','Get TF Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TF.script = TFipt.Func;
TF.beta = str2double(TFipt.('Beta'));
TF.weighting = (TFipt.('Weighting'));
TF.output = (TFipt.('Output'));

Status2('done','',2);
Status2('done','',3);