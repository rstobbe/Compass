%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,OBSHFT,err] = ObShiftCorMSYB_v2a(SCRPTipt,OBSHFTipt)

Status2('busy','Correct for Object Shifts Between Trajectories (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = OBSHFTipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
OBSHFT.method = OBSHFTipt.Func;
OBSHFT.trajmax = str2double(OBSHFTipt.('TrajMax'));
OBSHFT.imthresh = str2double(OBSHFTipt.('RelThresh'));
OBSHFT.imagefunc = OBSHFTipt.('Imagefunc').Func;
OBSHFT.obshftregfunc = OBSHFTipt.('ObShftRegfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMGipt = OBSHFTipt.('Imagefunc');
if isfield(OBSHFTipt,([CallingLabel,'_Data']))
    if isfield(OBSHFTipt.([CallingLabel,'_Data']),'Imagefunc_Data')
        IMGipt.('Imagefunc_Data') = OBSHFTipt.([CallingLabel,'_Data']).('Imagefunc_Data');
    end
end
OBSHFTREGipt = OBSHFTipt.('ObShftRegfunc');
if isfield(OBSHFTipt,([CallingLabel,'_Data']))
    if isfield(OBSHFTipt.([CallingLabel,'_Data']),'ObShftRegfunc_Data')
        OBSHFTREGipt.('ObShftRegfunc_Data') = OBSHFTipt.([CallingLabel,'_Data']).('ObShftRegfunc_Data');
    end
end

%------------------------------------------
% Get Image Creation Info
%------------------------------------------
func = str2func(OBSHFT.imagefunc);           
[SCRPTipt,IMG,err] = func(SCRPTipt,IMGipt);
if err.flag
    return
end

%------------------------------------------
% Get Rotation Correction Info
%------------------------------------------
func = str2func(OBSHFT.obshftregfunc);           
[SCRPTipt,OBSHFTREG,err] = func(SCRPTipt,OBSHFTREGipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
OBSHFT.IMG = IMG;
OBSHFT.OBSHFTREG = OBSHFTREG;

Status2('done','',2);
Status2('done','',3);

