%====================================================
% (v2a)
%    (v2) transition beta input   
%====================================================

function [SCRPTipt,SPIN,err] = Spin_ArbSampCent_v2a(SCRPTipt,SPINipt)

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
SPIN.beta = str2double(SPINipt.('TransBeta'));

Status2('done','',2);
Status2('done','',3);