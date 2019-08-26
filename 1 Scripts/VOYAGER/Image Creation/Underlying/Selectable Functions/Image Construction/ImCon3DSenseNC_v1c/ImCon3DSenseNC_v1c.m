%=====================================================
% (v1c)
%       - add max iterations
%=====================================================

function [SCRPTipt,SENSE,err] = ImCon3DSenseNC_v1c(SCRPTipt,SENSEipt)

Status2('busy','Non-Cartesian Sense Image Construction',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = SENSEipt.Struct.labelstr;
if not(isfield(SENSEipt,[CallingLabel,'_Data'])) || not(isfield(SENSEipt.([CallingLabel,'_Data']),'Imp_File_Data'))
    if isfield(SENSEipt.('Imp_File').Struct,'selectedfile')
        file = SENSEipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SENSEipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SENSEipt,[CallingLabel,'_Data'])) || not(isfield(SENSEipt.([CallingLabel,'_Data']),'SDC_File_Data'))
    if isfield(SENSEipt.('SDC_File').Struct,'selectedfile')
        file = SENSEipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SENSEipt.([CallingLabel,'_Data']).('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SENSEipt,[CallingLabel,'_Data'])) || not(isfield(SENSEipt.([CallingLabel,'_Data']),'Kern_File_Data'))
    if isfield(SENSEipt.('Kern_File').Struct,'selectedfile')
        file = SENSEipt.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SENSEipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end       
end
if not(isfield(SENSEipt,[CallingLabel,'_Data'])) || not(isfield(SENSEipt.([CallingLabel,'_Data']),'SenseProfs_File_Data'))
    if isfield(SENSEipt.('SenseProfs_File').Struct,'selectedfile')
        file = SENSEipt.('SenseProfs_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SenseProfs_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SENSEipt.([CallingLabel,'_Data']).('SenseProfs_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SenseProfs_File';
        ErrDisp(err);
        return
    end       
end
if not(isfield(SENSEipt,[CallingLabel,'_Data'])) || not(isfield(SENSEipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    if isfield(SENSEipt.('InvFilt_File').Struct,'selectedfile')
        file = SENSEipt.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SENSEipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load InvFilt_File';
        ErrDisp(err);
        return
    end       
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SENSE.method = SENSEipt.Func;
SENSE.gridfunc = SENSEipt.('Gridfunc').Func;
SENSE.gridrevfunc = SENSEipt.('GridRevfunc').Func;
SENSE.IMP = SENSEipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;
SENSE.SDCS = SENSEipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS;
SENSE.RcvrProf = SENSEipt.([CallingLabel,'_Data']).('SenseProfs_File_Data').SAMP.RcvrProf;
SENSE.KRNprms = SENSEipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;
SENSE.IFprms = SENSEipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;
SENSE.cgerrbreak = str2double(SENSEipt.('CGerr_Break'));
SENSE.maxits = str2double(SENSEipt.('MaxIts'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = SENSEipt.Struct.labelstr;
GRDipt = SENSEipt.('Gridfunc');
if isfield(SENSEipt,([CallingLabel,'_Data']))
    if isfield(SENSEipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = SENSEipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
GRDRipt = SENSEipt.('GridRevfunc');
if isfield(SENSEipt,([CallingLabel,'_Data']))
    if isfield(SENSEipt.([CallingLabel,'_Data']),'GridRevfunc_Data')
        GRDRipt.('GridRevfunc_Data') = SENSEipt.([CallingLabel,'_Data']).('GridRevfunc_Data');
    end
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SENSE.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SENSE.gridrevfunc);           
[SCRPTipt,GRDR,err] = func(SCRPTipt,GRDRipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
SENSE.GRD = GRD;
SENSE.GRDR = GRDR;

Status2('done','',2);
Status2('done','',3);

