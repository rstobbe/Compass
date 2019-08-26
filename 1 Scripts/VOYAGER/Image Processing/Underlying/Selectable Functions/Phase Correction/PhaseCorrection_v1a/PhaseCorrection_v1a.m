%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,PCOR,err] = PhaseCorrection_v1a(SCRPTipt,PCORipt)

Status2('done','Phase Correction Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PCOR.method = PCORipt.Func;
PCOR.profres = str2double(PCORipt.('PhaseRes'));
PCOR.proffilt = str2double(PCORipt.('PhaseFilt'));


Status2('done','',2);
Status2('done','',3);

