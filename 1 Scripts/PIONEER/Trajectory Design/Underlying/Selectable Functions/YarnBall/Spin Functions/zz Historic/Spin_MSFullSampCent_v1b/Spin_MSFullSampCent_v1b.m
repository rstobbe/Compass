%====================================================
% (v1b)
%     - linear transition and smoothing update  
%====================================================

function [SCRPTipt,SPIN,err] = Spin_MSFullSampCent_v1b(SCRPTipt,SPINipt)

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
SPIN.reltranslen = str2double(SPINipt.('RelTransLen'));
SPIN.smoothbeta = str2double(SPINipt.('SmoothBeta'));
SPIN.smoothcenshift = str2double(SPINipt.('SmoothCenShift'));

Status2('done','',2);
Status2('done','',3);