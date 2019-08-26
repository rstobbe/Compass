%=========================================================
% (v1b)
%      
%=========================================================

function [SCRPTipt,RLXMAP,err] = MapRelaxation_v1b(SCRPTipt,RLXMAPipt)

Status2('done','B1 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
RLXMAP.method = RLXMAPipt.Func;
RLXMAP.baseimfunc = RLXMAPipt.('BaseImfunc').Func;
RLXMAP.mapfunc = RLXMAPipt.('RelaxMapfunc').Func;

CallingLabel = RLXMAPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MAPFUNCipt = RLXMAPipt.('RelaxMapfunc');
if isfield(RLXMAPipt,([CallingLabel,'_Data']))
    if isfield(RLXMAPipt.([CallingLabel,'_Data']),'RelaxMapfunc_Data')
        MAPFUNCipt.('RelaxMapfunc_Data') = RLXMAPipt.([CallingLabel,'_Data']).('RelaxMapfunc_Data');
    end
end
BASEipt = RLXMAPipt.('BaseImfunc');
if isfield(RLXMAPipt,([CallingLabel,'_Data']))
    if isfield(RLXMAPipt.([CallingLabel,'_Data']),'BaseImfunc_Data')
        BASEipt.('BaseImfunc_Data') = RLXMAPipt.([CallingLabel,'_Data']).('BaseImfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(RLXMAP.mapfunc);           
[SCRPTipt,MAPFUNC,err] = func(SCRPTipt,MAPFUNCipt);
if err.flag
    return
end
func = str2func(RLXMAP.baseimfunc);           
[SCRPTipt,BASE,err] = func(SCRPTipt,BASEipt);
if err.flag
    return
end

RLXMAP.MAPFUNC = MAPFUNC;
RLXMAP.BASE = BASE;

Status2('done','',2);
Status2('done','',3);


