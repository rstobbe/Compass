%=========================================================
% (v1c)
%       - Moved Down to Underlying Function
%=========================================================

function [SCRPTipt,CORR,err] = CorrAbsNoise_v1c(SCRPTipt,CORRipt)

Status2('done','Correct for Effect of Absolute Value on Noise',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
CORR.sdvnoise = str2double(CORRipt.('SdvNoise'));

Status('done','');
Status2('done','',2);
Status2('done','',3);

