%====================================================
% (v1a)
%     - same as HemlockFreeUsamp_v3c / Ring_v1a
%====================================================

function [SCRPTipt,SPIN,err] = Spin_LightWorsted_v1a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.PolSamp = str2double(SPINipt.('PolSampFact'));
SPIN.AziSamp = str2double(SPINipt.('AziSampFact'));

Status2('done','',2);
Status2('done','',3);
