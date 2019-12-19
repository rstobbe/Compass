%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = TransFuncExpand_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.MaskThresh = str2double(MASKipt.('MaskThresh'));
MASK.Output = MASKipt.('Output');

%---------------------------------------------
% Tests
%---------------------------------------------
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
MASK.TfFile = MASKipt.('TF_File').EntryStr;
MASK.TF = MASKipt.([CallingLabel,'_Data']).TF_File_Data.TF;

Status2('done','',2);
Status2('done','',3);

