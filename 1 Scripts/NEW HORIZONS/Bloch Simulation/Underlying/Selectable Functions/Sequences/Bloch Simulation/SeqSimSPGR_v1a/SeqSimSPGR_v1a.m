%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SPGR,err] = SeqSimSPGR_v1a(SCRPTipt,SPGRipt)

Status2('busy','Simulate SPGR sequence',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
SPGR.script = SPGRipt.Func;
SPGR.flip = str2double(SPGRipt.('FlipAngle'));
SPGR.woff = str2double(SPGRipt.('Woff'));
SPGR.tau = str2double(SPGRipt.('RFtau'));
SPGR.rfspoil = str2double(SPGRipt.('RFspoil'));
SPGR.TR = str2double(SPGRipt.('TR'));
SPGR.TE = str2double(SPGRipt.('TE'));
SPGR.nsteady = str2double(SPGRipt.('NSteady'));
SPGR.simfunc = SPGRipt.('Simfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
CallingLabel = SPGRipt.Struct.labelstr;
SIMipt = SPGRipt.('Simfunc');
if isfield(SPGRipt,([CallingLabel,'_Data']))
    if isfield(SPGRipt.([CallingLabel,'_Data']),'Simfunc_Data')
        SIMipt.('Simfunc_Data') = SPGRipt.([CallingLabel,'_Data']).('Simfunc_Data');
    end
end

%------------------------------------------
% Sim Function Info
%------------------------------------------
func = str2func(SPGR.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
SPGR.SIM = SIM;


Status2('done','',2);
Status2('done','',3);