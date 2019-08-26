%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,PSTP,err] = PostProc_MSYBMTF_v1a(SCRPTipt,PSTPipt)

Status2('busy','Get Post Processing Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Panel Input
%---------------------------------------------
PSTP.method = PSTPipt.Func;
PSTP.fatfunc = PSTPipt.('FatSupressfunc').Func;
PSTP.mtfunc = PSTPipt.('MTfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = PSTPipt.Struct.labelstr;
FATipt = PSTPipt.('FatSupressfunc');
if isfield(PSTPipt,([CallingLabel,'_Data']))
    if isfield(PSTPipt.([CallingLabel,'_Data']),'FatSupressfunc_Data')
        FATipt.('FatSupressfunc_Data') = PSTPipt.([CallingLabel,'_Data']).('FatSupressfunc_Data');
    end
end
MTipt = PSTPipt.('MTfunc');
if isfield(PSTPipt,([CallingLabel,'_Data']))
    if isfield(PSTPipt.([CallingLabel,'_Data']),'MTfunc_Data')
        MTipt.('MTfunc_Data') = PSTPipt.([CallingLabel,'_Data']).('MTfunc_Data');
    end
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
func = str2func(PSTP.fatfunc);           
[SCRPTipt,FAT,err] = func(SCRPTipt,FATipt);
if err.flag
    return
end
func = str2func(PSTP.mtfunc);           
[SCRPTipt,MT,err] = func(SCRPTipt,MTipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSTP.FAT = FAT;
PSTP.MT = MT;

Status2('done','',2);
Status2('done','',3);







