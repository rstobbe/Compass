%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,REG,err] = Regression_MultiExp_v1a(SCRPTipt,REGipt)

Status2('busy','Multi-Experiment Regression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
REG.method = REGipt.Func;
REG.ModTestfunc = REGipt.('ModTestfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = REGipt.Struct.labelstr;
MODTSTipt = REGipt.('ModTestfunc');
if isfield(REGipt,([CallingLabel,'_Data']))
    if isfield(REGipt.([CallingLabel,'_Data']),'ModTestfunc_Data')
        MODTSTipt.('ModTestfunc_Data') = REGipt.([CallingLabel,'_Data']).('ModTestfunc_Data');
    end
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(REG.ModTestfunc);           
[SCRPTipt,MODTST,err] = func(SCRPTipt,MODTSTipt);
if err.flag
    return
end

REG.MODTST = MODTST;

Status2('done','',2);
Status2('done','',3);
