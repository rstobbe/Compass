%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GWCALC,err] = GrappaWCalc_v1a(SCRPTipt,GWCALCipt)

Status2('busy','Grappa Weight Calculation',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GWCALC.method = GWCALCipt.Func;

Status2('done','',2);
Status2('done','',3);







