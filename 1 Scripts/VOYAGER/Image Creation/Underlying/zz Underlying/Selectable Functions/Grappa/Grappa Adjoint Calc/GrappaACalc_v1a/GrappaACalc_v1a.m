%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GACALC,err] = GrappaACalc_v1a(SCRPTipt,GACALCipt)

Status2('busy','Grappa Adjoint Calculation',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GACALC.method = GACALCipt.Func;

Status2('done','',2);
Status2('done','',3);







