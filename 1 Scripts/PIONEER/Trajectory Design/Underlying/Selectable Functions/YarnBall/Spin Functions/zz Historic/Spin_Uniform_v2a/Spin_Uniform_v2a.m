%====================================================
% (v2a)
%     - allow non-rounded values  
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Uniform_v2a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));

Status2('done','',2);
Status2('done','',3);
