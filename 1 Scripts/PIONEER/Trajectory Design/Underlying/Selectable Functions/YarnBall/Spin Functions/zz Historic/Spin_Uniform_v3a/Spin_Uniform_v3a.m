%====================================================
% (v3a)
%     - Polar / Azimuthal Split
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Uniform_v3a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.PolSamp = str2double(SPINipt.('PolSampFact'));
SPIN.AziSamp = str2double(SPINipt.('AziSampFact'));
SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));
SPIN.SpiralOverShoot = str2double(SPINipt.('SpiralOverShoot'));

Status2('done','',2);
Status2('done','',3);
