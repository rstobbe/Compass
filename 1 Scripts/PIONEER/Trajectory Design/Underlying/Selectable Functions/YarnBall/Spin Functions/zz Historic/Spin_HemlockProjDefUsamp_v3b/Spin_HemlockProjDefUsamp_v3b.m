%====================================================
% (v3b)
%     - Start 'Spin_HemlockFreeUsamp_v3b'
%====================================================

function [SCRPTipt,SPIN,err] = Spin_HemlockProjDefUsamp_v3b(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.PolSamp = str2double(SPINipt.('PolSampFact'));
SPIN.nspokes = str2double(SPINipt.('Nspokes'));
SPIN.AziSamp = str2double(SPINipt.('AziSampFact'));
SPIN.ndiscs = str2double(SPINipt.('Ndiscs'));
SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));
SPIN.SpiralOverShoot = str2double(SPINipt.('SpiralOverShoot'));

Status2('done','',2);
Status2('done','',3);
