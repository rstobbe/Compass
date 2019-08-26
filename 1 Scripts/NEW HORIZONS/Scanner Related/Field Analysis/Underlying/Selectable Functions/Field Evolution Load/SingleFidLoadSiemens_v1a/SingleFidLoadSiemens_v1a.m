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
if not(isfield(FEVOLipt,[CallingLabel,'_Data']))
    if isfield(FEVOLipt.('File').Struct,'selectedfile')
        file = FEVOLipt.('File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File';
            ErrDisp(err);
            return
        else
            FEVOLipt.([CallingLabel,'_Data']).('File_Data').loc = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File';
        ErrDisp(err);
        return
    end
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
                saveData.path = file;
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
FEVOL.File = FEVOLipt.([CallingLabel,'_Data']).('File_Data').loc;
FEVOL.SysTest = FEVOLipt.([CallingLabel,'_Data']).('SysTest_Imp_Data');

Status2('done','',2);
Status2('done','',3);
