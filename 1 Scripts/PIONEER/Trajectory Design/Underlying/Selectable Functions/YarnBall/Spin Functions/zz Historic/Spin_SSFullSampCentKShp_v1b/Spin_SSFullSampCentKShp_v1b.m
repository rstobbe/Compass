%====================================================
% (v1b)
%     -  
%====================================================

function [SCRPTipt,SPIN,err] = Spin_SSFullSampCentKShp_v1b(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.CentDiam = str2double(SPINipt.('CentDiam'));
SPIN.CentScale = str2double(SPINipt.('CentScale'));
SPIN.AddShpStartVal = str2double(SPINipt.('AddShpStartVal'));
SPIN.AddShpEndVal = str2double(SPINipt.('AddShpEndVal'));
SPIN.AddShpBeta = str2double(SPINipt.('AddShpBeta'));
SPIN.reltranslen = str2double(SPINipt.('RelTransLen'));
SPIN.smoothbeta = str2double(SPINipt.('SmoothBeta'));
SPIN.smoothcenshift = str2double(SPINipt.('SmoothCenShift'));

Status2('done','',2);
Status2('done','',3);