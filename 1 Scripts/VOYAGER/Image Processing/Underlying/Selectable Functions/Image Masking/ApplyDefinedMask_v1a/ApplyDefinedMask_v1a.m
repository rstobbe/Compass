%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,MASKTOP,err] = ApplyDefinedMask_v1a(SCRPTipt,MASKTOPipt)

Status2('busy','Apply Mask',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASKTOP.method = MASKTOPipt.Func;
MASKTOP.maskfunc = MASKTOPipt.('Maskfunc').Func;

CallingLabel = MASKTOPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MASKipt = MASKTOPipt.('Maskfunc');
if isfield(MASKTOPipt,([CallingLabel,'_Data']))
    if isfield(MASKTOPipt.([CallingLabel,'_Data']),'Maskfunc_Data')
        MASKipt.('Maskfunc_Data') = MASKTOPipt.([CallingLabel,'_Data']).('Maskfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(MASKTOP.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end

MASKTOP.MASK = MASK;


Status2('done','',2);
Status2('done','',3);







