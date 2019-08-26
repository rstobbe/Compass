%=========================================================
%
%=========================================================

function [LOAD,err] = LoadRawData_Simulation_v1a_Func(LOAD,INPUT)

Status2('busy','Load Simulation Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LOAD.Data = single(LOAD.SAMP.SampDat);
LOAD.Data = repmat(LOAD.Data,[1,1,4]);
LOAD.Data = permute(LOAD.Data,[3,1,2]);

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);
