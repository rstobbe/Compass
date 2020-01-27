%=========================================================
% (v1b) 
%      
%=========================================================

function [SCRPTipt,FITDIST,err] = FitDistTool_v1b(SCRPTipt,FITDISTipt)

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
