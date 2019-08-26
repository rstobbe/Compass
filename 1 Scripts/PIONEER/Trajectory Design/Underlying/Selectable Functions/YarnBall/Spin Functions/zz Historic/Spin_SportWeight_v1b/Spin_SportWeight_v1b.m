%====================================================
% (v1b)
%     - general update
%====================================================

function [SCRPTipt,SPIN,err] = Spin_SportWeight_v1b(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.ForceOddSpokes = SPINipt.('ForceOddSpokes');
SPIN.AziSamp = str2double(SPINipt.('AziSampFact'));
SPIN.PolSamp = str2double(SPINipt.('PolSampFact'));

Status2('done','',2);
Status2('done','',3);
