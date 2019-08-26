%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,PCOR,err] = DtiSiemensPhaseCor_v1a(SCRPTipt,PCORipt)

Status2('busy','Phase Correct Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
PCOR.method = PCORipt.Func;

Status2('done','',2);
Status2('done','',3);

