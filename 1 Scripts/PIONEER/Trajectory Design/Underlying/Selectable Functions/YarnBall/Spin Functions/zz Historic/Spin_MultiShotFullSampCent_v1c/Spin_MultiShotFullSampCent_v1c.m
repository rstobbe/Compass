%====================================================
% (v1c)
%     - Include Spawning Factor
%====================================================

function [SCRPTipt,SPIN,err] = Spin_MultiShotFullSampCent_v1c(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.CentDiam = str2double(SPINipt.('CentDiam'));
SPIN.reltranslen = str2double(SPINipt.('RelTransLen'));
SPIN.smoothbeta = str2double(SPINipt.('SmoothBeta'));
SPIN.smoothcenshift = str2double(SPINipt.('SmoothCenShift'));
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));
SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));
SPIN.SpiralOverShoot = str2double(SPINipt.('SpiralOverShoot'));

Status2('done','',2);
Status2('done','',3);