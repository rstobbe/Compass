%=========================================================
% (v1f) 
%       - start pCASL_Tagging2_v1f
%=========================================================

function [SCRPTipt,CASL,err] = pCASL_Tagging2inhomo_v1f(SCRPTipt,CASLipt)

Status2('busy','pCASL Tagging Sequence',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = CASLipt.Struct.labelstr;
if not(isfield(CASLipt,[CallingLabel,'_Data']))
    if isfield(CASLipt.('RF_File').Struct,'selectedfile')
        file = CASLipt.('RF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load RF_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load RF File',2);
            saveData.file = file;
            CASLipt.([CallingLabel,'_Data']).('RF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load RF_File';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Return Input
%---------------------------------------------
CASL.script = CASLipt.Func;
CASL.rffa = str2double(CASLipt.('RF_FA'));
CASL.rftau = str2double(CASLipt.('RF_tau'));
CASL.gss = str2double(CASLipt.('Gss'));
CASL.delg = str2double(CASLipt.('delG'));
CASL.delb0 = str2double(CASLipt.('delB0'));
CASL.simulationwid = str2double(CASLipt.('SimulationWid'));
CASL.dutycycle = str2double(CASLipt.('DutyCycle'));
CASL.gave = str2double(CASLipt.('Gave'));
CASL.TagControl = CASLipt.('TagControl');
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