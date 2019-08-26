%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,PLTDIST,err] = PlotRoiDistribution_v1a(SCRPTipt,FITDISTipt)

Status2('busy','Plot Roi Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PLTDIST.method = FITDISTipt.Func;

Status2('done','',2);
Status2('done','',3);
