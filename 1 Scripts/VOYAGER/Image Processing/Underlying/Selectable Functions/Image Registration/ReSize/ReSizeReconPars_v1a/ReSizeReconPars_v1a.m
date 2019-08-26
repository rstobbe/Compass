%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,RSZ,err] = ReSizeReconPars_v1a(SCRPTipt,RSZipt)

Status2('done','Image Resize',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
RSZ.method = RSZipt.Func;
RSZ.beta = str2double(RSZipt.('FilterBeta'));

Status2('done','',2);
Status2('done','',3);