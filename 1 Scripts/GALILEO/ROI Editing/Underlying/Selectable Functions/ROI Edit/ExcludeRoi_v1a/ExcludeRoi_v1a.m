%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = ExcludeRoi_v1a(SCRPTipt,MASKipt)

Status2('busy','Create Mask From Roi',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASK.method = MASKipt.Func;

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
MASK.RoiFile = MASKipt.('Roi_File').EntryStr;
MASK.ROI = MASKipt.('Roi_File').Struct;

Status2('done','',2);
Status2('done','',3);


