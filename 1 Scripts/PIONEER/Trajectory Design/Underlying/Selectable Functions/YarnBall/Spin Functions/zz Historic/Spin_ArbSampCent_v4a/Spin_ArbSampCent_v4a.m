%====================================================
% (v4a)
%    - (v4) linear transition in terms of slope speed    
%====================================================

function [SCRPTipt,SPIN,err] = Spin_ArbSampCent_v4a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.FSMD = str2double(SPINipt.('CentDiam'));
SPIN.CenSamp = str2double(SPINipt.('CentSampFact'));
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));
SPIN.reltranslen = str2double(SPINipt.('RelTransLen'));

Status2('done','',2);
Status2('done','',3);