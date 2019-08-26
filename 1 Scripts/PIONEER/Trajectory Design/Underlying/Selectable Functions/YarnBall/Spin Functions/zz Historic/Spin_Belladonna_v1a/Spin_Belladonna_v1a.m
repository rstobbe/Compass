%====================================================
% (v1a)
%     - For use with 'Yarn-Ball' proj dist 
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Belladonna_v1a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;

Status2('done','',2);
Status2('done','',3);
