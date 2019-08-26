%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SPIN,err] = Spin_SSFullSampCent_v1a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.FSMD = str2double(SPINipt.('CentDiam'));
SPIN.CenSamp = str2double(SPINipt.('SSCentSampFact'));
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));

Status2('done','',2);
Status2('done','',3);