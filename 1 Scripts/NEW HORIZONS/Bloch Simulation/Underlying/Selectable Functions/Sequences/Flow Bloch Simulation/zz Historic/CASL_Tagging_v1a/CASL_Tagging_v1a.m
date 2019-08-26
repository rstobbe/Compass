%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,CSAT,err] = CASL_Tagging_v1a(SCRPTipt,CSATipt)

Status2('busy','CASL Tagging Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
CSAT.script = CSATipt.Func;
CSAT.rffa = str2double(CSATipt.('RF_FA'));
CSAT.rftau = str2double(CSATipt.('RF_tau'));
CSAT.grad = str2double(CSATipt.('Grad'));
CSAT.excitewid = str2double(CSATipt.('ExciteWid'));
CSAT.simfunc = CSATipt.('Simfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
CallingLabel = CSATipt.Struct.labelstr;
SIMipt = CSATipt.('Simfunc');
if isfield(CSATipt,([CallingLabel,'_Data']))
    if isfield(CSATipt.([CallingLabel,'_Data']),'Simfunc_Data')
        SIMipt.('Simfunc_Data') = CSATipt.([CallingLabel,'_Data']).('Simfunc_Data');
    end
end

%------------------------------------------
% Sim Function Info
%------------------------------------------
func = str2func(CSAT.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CSAT.SIM = SIM;


Status2('done','',2);
Status2('done','',3);