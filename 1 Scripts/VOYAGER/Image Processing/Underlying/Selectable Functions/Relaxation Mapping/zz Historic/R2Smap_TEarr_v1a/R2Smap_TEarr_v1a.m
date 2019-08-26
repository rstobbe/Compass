%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,MAP,err] = R2Smap_TEarr_v1a(SCRPTipt,MAPipt)

Status2('done','R2S Mapping (TE array) Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MAP.method = MAPipt.Func;
MAP.calcfunc = MAPipt.('Calcfunc').Func;
MAP.MV = str2double(MAPipt.('RelMaskVal'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = MAPipt.Struct.labelstr;
CALCipt = MAPipt.('Calcfunc');
if isfield(MAPipt,([CallingLabel,'_Data']))
    if isfield(MAPipt.([CallingLabel,'_Data']),'Calcfunc_Data')
        CALCipt.('Calcfunc_Data') = MAPipt.([CallingLabel,'_Data']).('Calcfunc_Data');
    end
end

%------------------------------------------
% Get Calcding Info
%------------------------------------------
func = str2func(MAP.calcfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

MAP.CALC = CALC;

Status2('done','',2);
Status2('done','',3);

