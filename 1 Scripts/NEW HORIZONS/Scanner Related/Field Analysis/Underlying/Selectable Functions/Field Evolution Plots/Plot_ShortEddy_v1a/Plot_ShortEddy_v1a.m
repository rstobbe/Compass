%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,FPLT,err] = Plot_LongEddy_v1a(SCRPTipt,FPLTipt)

Status2('busy','Plotting Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FPLT.method = FPLTipt.Func;

Status2('done','',2);
Status2('done','',3);
