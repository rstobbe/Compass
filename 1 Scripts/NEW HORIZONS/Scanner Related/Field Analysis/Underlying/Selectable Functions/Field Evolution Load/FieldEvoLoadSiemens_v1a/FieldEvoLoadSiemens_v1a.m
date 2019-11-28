%====================================================
% (v1a)
%           
%====================================================

function [SCRPTipt,FEVOL,err] = FieldEvoLoadSiemens_v1a(SCRPTipt,FEVOLipt)

Status2('busy','Load Siemens Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = FEVOLipt.Struct.labelstr;
LoadAll = 0;
if not(isfield(FEVOLipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(FEVOLipt.([CallingLabel,'_Data']),'File_Pos1_Data'))
    if isfield(FEVOLipt.('File_Pos1').Struct,'selectedfile')
        file = FEVOLipt.('File_Pos1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Pos1';
            ErrDisp(err);
            return
        else
            FEVOLipt.([CallingLabel,'_Data']).('File_Pos1_Data').loc = file;
            FEVOLipt.([CallingLabel,'_Data']).('File_Pos1_Data').path = FEVOLipt.('File_Pos1').Struct.selectedpath;
            FEVOLipt.([CallingLabel,'_Data']).('File_Pos1_Data').file = FEVOLipt.('File_Pos1').Struct.filename;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Pos1';
        ErrDisp(err);
        return
    end
end
if LoadAll == 1 || not(isfield(FEVOLipt.([CallingLabel,'_Data']),'File_Pos2_Data'))
    if isfield(FEVOLipt.('File_Pos2').Struct,'selectedfile')
        file = FEVOLipt.('File_Pos2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Pos2';
            ErrDisp(err);
            return
        else
            FEVOLipt.([CallingLabel,'_Data']).('File_Pos2_Data').loc = file;
            FEVOLipt.([CallingLabel,'_Data']).('File_Pos2_Data').path = FEVOLipt.('File_Pos2').Struct.selectedpath;
            FEVOLipt.([CallingLabel,'_Data']).('File_Pos2_Data').file = FEVOLipt.('File_Pos2').Struct.filename;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Pos2';
        ErrDisp(err);
        return
    end
end
if LoadAll == 1 || not(isfield(FEVOLipt.([CallingLabel,'_Data']),'SysTest_Imp_Data'))
    if not(isfield(FEVOLipt.([CallingLabel,'_Data']),'SysTest_Imp_Data'))
        if isfield(FEVOLipt.('SysTest_Imp').Struct,'selectedfile')
            file = FEVOLipt.('SysTest_Imp').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load SysTest_Imp';
                ErrDisp(err);
                return
            else
                Status2('busy','Load SysTest Data',2);
                load(file);
                saveData.path = FEVOLipt.('SysTest_Imp').Struct.selectedpath;
                saveData.IMP.name = FEVOLipt.('SysTest_Imp').Struct.filename;
                FEVOLipt.([CallingLabel,'_Data']).('SysTest_Imp_Data') = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load SysTest_Imp';
            ErrDisp(err);
            return
        end
    end        
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FEVOL.method = FEVOLipt.Func;
FEVOL.File_Pos1.loc = FEVOLipt.([CallingLabel,'_Data']).('File_Pos1_Data').loc;
FEVOL.File_Pos2.loc = FEVOLipt.([CallingLabel,'_Data']).('File_Pos2_Data').loc;
FEVOL.File_Pos1.name = FEVOLipt.([CallingLabel,'_Data']).('File_Pos1_Data').file;
FEVOL.File_Pos2.name = FEVOLipt.([CallingLabel,'_Data']).('File_Pos2_Data').file;
FEVOL.SysTest = FEVOLipt.([CallingLabel,'_Data']).('SysTest_Imp_Data');
FEVOL.path = FEVOLipt.([CallingLabel,'_Data']).('File_Pos2_Data').path;

Status2('done','',2);
Status2('done','',3);
