%====================================================
% (v3c)
%     - Input Fix Up
%====================================================

function [SCRPTipt,SPIN,err] = Spin_HemlockProjDefUsamp_v3c(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.UnderSamp = str2double(SPINipt.('UnderSampFact'));
SPIN.nspokes = str2double(SPINipt.('Nspokes'));
SPIN.ndiscs = str2double(SPINipt.('Ndiscs'));
SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));
SPIN.SpiralOverShoot = str2double(SPINipt.('SpiralOverShoot'));

Status2('done','',2);
Status2('done','',3);
