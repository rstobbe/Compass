%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,MASK,err] = BrainMask1_v1a(SCRPTipt,MASKipt)

Status2('busy','Brain Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = MASKipt.Struct.labelstr;
%---------------------------------------------
% Get Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.maskfovfunc = MASKipt.('MaskFoVfunc').Func;
MASK.maskfreqfunc = MASKipt.('MaskFreqfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MFOVipt = MASKipt.('MaskFoVfunc');
if isfield(MASKipt,([CallingLabel,'_Data']))
    if isfield(MASKipt.([CallingLabel,'_Data']),'MaskFoVfunc_Data')
        MFOVipt.('MaskFoVfunc_Data') = MASKipt.([CallingLabel,'_Data']).('MaskFoVfunc_Data');
    end
end
MFRQipt = MASKipt.('MaskFreqfunc');
if isfield(MASKipt,([CallingLabel,'_Data']))
    if isfield(MASKipt.([CallingLabel,'_Data']),'MaskFreqfunc_Data')
        MFRQipt.('MaskFreqfunc_Data') = MASKipt.([CallingLabel,'_Data']).('MaskFreqfunc_Data');
    end
end

%------------------------------------------
% Get Fov Mask Info
%------------------------------------------
func = str2func(MASK.maskfovfunc);           
[SCRPTipt,MFOV,err] = func(SCRPTipt,MFOVipt);
if err.flag
    return
end

%------------------------------------------
% Get Freq Mask Info
%------------------------------------------
func = str2func(MASK.maskfreqfunc);           
[SCRPTipt,MFRQ,err] = func(SCRPTipt,MFRQipt);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
MASK.MFOV = MFOV;
MASK.MFRQ = MFRQ;

Status('done','');
Status2('done','',2);
Status2('done','',3);

