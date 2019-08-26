%=========================================================
% (v1b) 
%     - Update to facilitate gridding onto zero-filled matrix
%=========================================================

function [SCRPTipt,IC,err] = ImCon3DGridding_v1b(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

IC = struct();
CallingLabel = ICipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(ICipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Imp_File_Data'))
    if isfield(ICipt.('Imp_File').Struct,'selectedfile')
        file = ICipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Implementation Data',2);
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'SDC_File_Data'))
    if isfield(ICipt.('SDC_File').Struct,'selectedfile')
        file = ICipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load SDC Data',2);            
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    if isfield(ICipt.('InvFilt_File').Struct,'selectedfile')
        file = ICipt.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Inversion Filter Data',2);
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load InvFilt_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.gridfunc = ICipt.('Gridfunc').Func;
IC.returnfov = ICipt.('ReturnFoV');
IC.orientfunc = ICipt.('Orientfunc').Func;
IC.IMP = ICipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;
IC.SDCS = ICipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS;
IC.IFprms = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = ICipt.('Gridfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = ICipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
ORNTipt = ICipt.('Orientfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Orientfunc_Data')
        ORNTipt.('Orientfunc_Data') = ICipt.([CallingLabel,'_Data']).('Orientfunc_Data');
    end
end

%------------------------------------------
% Get Gridding Info
%------------------------------------------
func = str2func(IC.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% Get Post Processing Info
%------------------------------------------
func = str2func(IC.orientfunc);           
[SCRPTipt,ORNT,err] = func(SCRPTipt,ORNTipt);
if err.flag
    return
end


%------------------------------------------
% Return
%------------------------------------------
IC.GRD = GRD;
IC.ORNT = ORNT;

Status2('done','',2);
Status2('done','',3);

