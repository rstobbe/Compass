%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,LOAD,err] = LoadConvKern_Standard_v1a(SCRPTipt,LOADipt)

Status2('busy','Load Convolution Kernel',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

LOAD = struct();
CallingLabel = LOADipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(LOADipt,[CallingLabel,'_Data']))
    if isfield(LOADipt.('Kern_File').Struct,'selectedfile')
        file = LOADipt.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            LOADipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
LOAD.method = LOADipt.Func;
LOAD.DatName = LOADipt.('Kern_File').EntryStr;
LOAD.KERN = LOADipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;
LOAD.path = LOADipt.([CallingLabel,'_Data']).('Kern_File_Data').path;

Status2('done','',2);
Status2('done','',3);
