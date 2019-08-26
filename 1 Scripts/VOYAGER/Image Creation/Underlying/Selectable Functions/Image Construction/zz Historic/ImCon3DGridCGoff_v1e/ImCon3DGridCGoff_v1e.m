%=====================================================
% (v1e)
%       - Algorithm change
%=====================================================

function [SCRPTipt,GCGB0,err] = ImCon3DGridCGoff_v1e(SCRPTipt,GCGB0ipt)

Status2('busy','Gridding With CG B0 Correction',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GCGB0ipt.Struct.labelstr;
if not(isfield(GCGB0ipt,[CallingLabel,'_Data'])) || not(isfield(GCGB0ipt.([CallingLabel,'_Data']),'Imp_File_Data'))
    if isfield(GCGB0ipt.('Imp_File').Struct,'selectedfile')
        file = GCGB0ipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            GCGB0ipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(GCGB0ipt,[CallingLabel,'_Data'])) || not(isfield(GCGB0ipt.([CallingLabel,'_Data']),'SDC_File_Data'))
    if isfield(GCGB0ipt.('SDC_File').Struct,'selectedfile')
        file = GCGB0ipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            GCGB0ipt.([CallingLabel,'_Data']).('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(GCGB0ipt,[CallingLabel,'_Data'])) || not(isfield(GCGB0ipt.([CallingLabel,'_Data']),'Kern_File_Data'))
    if isfield(GCGB0ipt.('Kern_File').Struct,'selectedfile')
        file = GCGB0ipt.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            GCGB0ipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end       
end
if not(isfield(GCGB0ipt,[CallingLabel,'_Data'])) || not(isfield(GCGB0ipt.([CallingLabel,'_Data']),'B0Map_File_Data'))
    if isfield(GCGB0ipt.('B0Map_File').Struct,'selectedfile')
        file = GCGB0ipt.('B0Map_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load B0Map_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            GCGB0ipt.([CallingLabel,'_Data']).('B0Map_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load B0Map_File';
        ErrDisp(err);
        return
    end       
end
if not(isfield(GCGB0ipt,[CallingLabel,'_Data'])) || not(isfield(GCGB0ipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    if isfield(GCGB0ipt.('InvFilt_File').Struct,'selectedfile')
        file = GCGB0ipt.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            GCGB0ipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
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
GCGB0.method = GCGB0ipt.Func;
GCGB0.gridfunc = GCGB0ipt.('Gridfunc').Func;
GCGB0.ksampfunc = GCGB0ipt.('kSampfunc').Func;
GCGB0.IMP = GCGB0ipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;
GCGB0.SDCS = GCGB0ipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS;
GCGB0.B0Map = GCGB0ipt.([CallingLabel,'_Data']).('B0Map_File_Data').B0Map;
GCGB0.KRNprms = GCGB0ipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;
GCGB0.IFprms = GCGB0ipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;
GCGB0.cgerrbreak = str2double(GCGB0ipt.('CGerr_Break'));
GCGB0.maxits = str2double(GCGB0ipt.('MaxIts'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = GCGB0ipt.Struct.labelstr;
GRDipt = GCGB0ipt.('Gridfunc');
if isfield(GCGB0ipt,([CallingLabel,'_Data']))
    if isfield(GCGB0ipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = GCGB0ipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
KSMPipt = GCGB0ipt.('kSampfunc');
if isfield(GCGB0ipt,([CallingLabel,'_Data']))
    if isfield(GCGB0ipt.([CallingLabel,'_Data']),'kSampfunc_Data')
        KSMPipt.('kSampfunc_Data') = GCGB0ipt.([CallingLabel,'_Data']).('kSampfunc_Data');
    end
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(GCGB0.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(GCGB0.ksampfunc);           
[SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
GCGB0.GRD = GRD;
GCGB0.KSMP = KSMP;

Status2('done','',2);
Status2('done','',3);

