%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,OUT,err] = Output_SampleOverAcq_v1a(SCRPTipt,OUTipt)

Status2('busy','Output Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
OUT.method = OUTipt.Func;
OUT.acqtimes = OUTipt.('AcqTimes');

Status2('done','',2);
Status2('done','',3);