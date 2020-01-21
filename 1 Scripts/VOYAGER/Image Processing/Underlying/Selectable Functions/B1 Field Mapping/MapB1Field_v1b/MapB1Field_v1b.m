%=========================================================
% (v1b)
%    - Plot to Compass (IM1)
%=========================================================

function [SCRPTipt,B1MAP,err] = MapB1Field_v1b(SCRPTipt,B1MAPipt)

Status2('done','B1 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B1MAP.method = B1MAPipt.Func;
B1MAP.baseimfunc = B1MAPipt.('BaseImfunc').Func;
B1MAP.mapfunc = B1MAPipt.('B1Mapfunc').Func;
B1MAP.return = B1MAPipt.('Return');
B1MAP.plot = B1MAPipt.('Plot');
B1MAP.output = B1MAPipt.('Output');

CallingLabel = B1MAPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MAPFUNCipt = B1MAPipt.('B1Mapfunc');
if isfield(B1MAPipt,([CallingLabel,'_Data']))
    if isfield(B1MAPipt.([CallingLabel,'_Data']),'B1Mapfunc_Data')
        MAPFUNCipt.('B1Mapfunc_Data') = B1MAPipt.([CallingLabel,'_Data']).('B1Mapfunc_Data');
    end
end
BASEipt = B1MAPipt.('BaseImfunc');
if isfield(B1MAPipt,([CallingLabel,'_Data']))
    if isfield(B1MAPipt.([CallingLabel,'_Data']),'BaseImfunc_Data')
        BASEipt.('BaseImfunc_Data') = B1MAPipt.([CallingLabel,'_Data']).('BaseImfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(B1MAP.mapfunc);           
[SCRPTipt,MAPFUNC,err] = func(SCRPTipt,MAPFUNCipt);
if err.flag
    return
end
func = str2func(B1MAP.baseimfunc);           
[SCRPTipt,BASE,err] = func(SCRPTipt,BASEipt);
if err.flag
    return
end


B1MAP.MAPFUNC = MAPFUNC;
B1MAP.BASE = BASE;

Status2('done','',2);
Status2('done','',3);


