%====================================================
% (v1a)
%     
%====================================================

function [SCRPTipt,SPIN,err] = Spin_KaiserShaped_v1a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;

SPIN.sampshift = str2double(SPINipt.('SampShift'));
SPIN.sampend = str2double(SPINipt.('SampEnd'));
SPIN.sampstart = str2double(SPINipt.('SampStart'));
SPIN.sampbeta = str2double(SPINipt.('SampBeta'));

SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));
SPIN.SpiralOverShoot = str2double(SPINipt.('SpiralOverShoot'));


Status2('done','',2);
Status2('done','',3);
