%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,CGC,err] = ConcomitantGradCalc_v1a(SCRPTipt,CGCipt)

Status2('busy','Concomitant Gradient Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
CGC.method = CGCipt.Func;
CGC.startfromzero = CGCipt.('StartFromZero');

Status2('done','',2);
Status2('done','',3);


