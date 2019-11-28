%=====================================================
% (v1b)
%           - OvrSamp hard set to value of 1 (must be for SysTest code)
%=====================================================

function [SCRPTipt,GTSAMP,err] = GradTestSamp_v1b(SCRPTipt,GTSAMPipt)

Status2('busy','Gradient Test Sampling',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GTSAMP.method = GTSAMPipt.Func;
GTSAMP.dwell = str2double(GTSAMPipt.('SampDwell'));
GTSAMP.tro = str2double(GTSAMPipt.('Tro'));

Status2('done','',2);
Status2('done','',3);







