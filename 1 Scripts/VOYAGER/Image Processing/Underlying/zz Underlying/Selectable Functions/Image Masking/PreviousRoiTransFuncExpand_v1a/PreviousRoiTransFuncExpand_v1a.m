%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = PreviousRoiTransFuncExpand_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.NanMask = MASKipt.('NanMask');
MASK.NanMaskThresh = str2double(MASKipt.('NanMaskThresh'));
MASK.Output = MASKipt.('Output');

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = MASKipt.Struct.labelstr;
if not(isfield(MASKipt,[CallingLabel,'_Data']))
    if isfield(MASKipt.('Roi_File').Struct,'selectedfile')
        file = MASKipt.('Roi_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Roi_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Roi_File',2);              % needs fixing in here...
            load(file);
            saveData.path = file;
            MASKipt.([CallingLabel,'_Data']).('Roi_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Roi_File';
        ErrDisp(err);
        return
    end    
end

CallingLabel = MASKipt.Struct.labelstr;
if not(isfield(MASKipt,[CallingLabel,'_Data']))
    if isfield(MASKipt.('TF_File').Struct,'selectedfile')
        file = MASKipt.('TF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load TF_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load TF_File',2);
            load(file);
            saveData.path = file;
            MASKipt.([CallingLabel,'_Data']).('TF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load TF_File';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASK.RoiFile = MASKipt.('Roi_File').EntryStr;
MASK.ROI = MASKipt.('Roi_File').Struct;
MASK.TfFile = MASKipt.('TF_File').EntryStr;
MASK.TF = MASKipt.([CallingLabel,'_Data']).TF_File_Data.TF;

Status2('done','',2);
Status2('done','',3);

