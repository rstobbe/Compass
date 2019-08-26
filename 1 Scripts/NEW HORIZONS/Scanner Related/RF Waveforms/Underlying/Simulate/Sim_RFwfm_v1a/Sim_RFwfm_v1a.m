%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,TST,err] = Sim_RFwfm_v1a(SCRPTipt,TSTipt)

Status2('busy','Simulate RF waveform',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TST.method = TSTipt.Func;
TST.blochfunc = TSTipt.('Blochfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = TSTipt.Struct.labelstr;
BLOCHipt = TSTipt.('Blochfunc');
if isfield(TSTipt,([CallingLabel,'_Data']))
    if isfield(TSTipt.([CallingLabel,'_Data']),'Blochfunc_Data')
        BLOCHipt.('Blochfunc_Data') = TSTipt.([CallingLabel,'_Data']).('Blochfunc_Data');
    end
end

%------------------------------------------
% Get BLOCH Info
%------------------------------------------
func = str2func(TST.blochfunc);           
[SCRPTipt,BLOCH,err] = func(SCRPTipt,BLOCHipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
TST.BLOCH = BLOCH;

Status2('done','',2);
Status2('done','',3);



