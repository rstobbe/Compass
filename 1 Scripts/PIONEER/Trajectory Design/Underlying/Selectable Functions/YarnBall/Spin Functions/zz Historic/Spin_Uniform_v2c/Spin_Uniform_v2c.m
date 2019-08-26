%====================================================
% (v2c)
%     - Include 'Spiral Overshoot'
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Uniform_v2c(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));
SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));
SPIN.SpiralOverShoot = str2double(SPINipt.('SpiralOverShoot'));

Status2('done','',2);
Status2('done','',3);
