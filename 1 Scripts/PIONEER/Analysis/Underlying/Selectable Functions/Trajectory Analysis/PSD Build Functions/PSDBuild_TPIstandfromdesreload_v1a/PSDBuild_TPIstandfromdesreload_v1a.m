%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,PSD,err] = PSDBuild_TPIdesreload_v1a(SCRPTipt,PSDipt)

Status2('done','PSD Build Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

PSD = struct();
CallingLabel = PSDipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(PSDipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(PSDipt.([CallingLabel,'_Data']),'DES_File_Data'))
    if isfield(PSDipt.('DES_File').Struct,'selectedfile')
        file = PSDipt.('DES_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load DES_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load DES Data',2);            
            load(file);
            saveData.path = file;
            PSDipt.([CallingLabel,'_Data']).('DES_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load DES_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSD.method = PSDipt.Func;
PSD.DES = PSDipt.([CallingLabel,'_Data']).('DES_File_Data').DES;

Status2('done','',2);
Status2('done','',3);








