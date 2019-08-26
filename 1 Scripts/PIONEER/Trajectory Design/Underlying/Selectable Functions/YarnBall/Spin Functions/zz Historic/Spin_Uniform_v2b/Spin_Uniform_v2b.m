%====================================================
% (v2b)
%     - Include 'SpawningFactor' & 'CentSpinFactor'
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Uniform_v2b(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));
SPIN.SpawnFact = str2double(SPINipt.('SpawningFact'));
SPIN.CentSpinFact = str2double(SPINipt.('CentreSpinFact'));

Status2('done','',2);
Status2('done','',3);
