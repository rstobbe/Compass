%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,FITDIST,err] = FitDist_v1a(SCRPTipt,FITDISTipt)

Status2('busy','Fit Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FITDIST.method = FITDISTipt.Func;

Status2('done','',2);
Status2('done','',3);
