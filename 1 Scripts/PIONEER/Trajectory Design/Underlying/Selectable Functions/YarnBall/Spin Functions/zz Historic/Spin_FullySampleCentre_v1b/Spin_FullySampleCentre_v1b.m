%====================================================
% (v1b)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,SPIN,err] = Spin_FullySampleCentre_v1b(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN = struct();
SPIN.FSMD = SPINipt.('FullSampMatDiam');
SPIN.CenSamp = SPINipt.('CentSampFactor');

Status2('done','',2);
Status2('done','',3);