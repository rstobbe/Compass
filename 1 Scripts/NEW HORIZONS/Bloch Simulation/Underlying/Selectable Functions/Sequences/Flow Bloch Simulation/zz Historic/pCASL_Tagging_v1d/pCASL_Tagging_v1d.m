%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,CASL,err] = pCASL_Tagging_v1d(SCRPTipt,CASLipt)

Status2('busy','CASL Tagging Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = CASLipt.Struct.labelstr;
%---------------------------------------------
% Return Input
%---------------------------------------------
CASL.script = CASLipt.Func;
CASL.rffa = str2double(CASLipt.('RF_FA'));
CASL.rftau = str2double(CASLipt.('RF_tau'));
CASL.excitewid = str2double(CASLipt.('ExciteWid'));
CASL.simulationwid = str2double(CASLipt.('SimulationWid'));
CASL.dutycycle = str2double(CASLipt.('DutyCycle'));
CASL.SSaref = CASLipt.('SSaref');
CASL.simfunc = CASLipt.('Simfunc').Func;
CASL.RFfile = CASLipt.([CallingLabel,'_Data']).('RF_File_Data').file;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
CallingLabel = CASLipt.Struct.labelstr;
SIMipt = CASLipt.('Simfunc');
if isfield(CASLipt,([CallingLabel,'_Data']))
    if isfield(CASLipt.([CallingLabel,'_Data']),'Simfunc_Data')
        SIMipt.('Simfunc_Data') = CASLipt.([CallingLabel,'_Data']).('Simfunc_Data');
    end
end

%------------------------------------------
% Sim Function Info
%------------------------------------------
func = str2func(CASL.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CASL.SIM = SIM;


Status2('done','',2);
Status2('done','',3);