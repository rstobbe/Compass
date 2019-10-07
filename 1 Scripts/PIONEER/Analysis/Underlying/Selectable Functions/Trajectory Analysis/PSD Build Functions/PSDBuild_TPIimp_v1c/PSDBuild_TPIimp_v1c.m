%===========================================
% (v1c)
%    - Add orientation
%    - Scaling of SNR altered for 'Iterate_DblConv_v1n' and onward
%===========================================

function [SCRPTipt,PSD,err] = PSDBuild_TPIimp_v1c(SCRPTipt,PSDipt)

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
if LoadAll == 1 || not(isfield(PSDipt.([CallingLabel,'_Data']),'SDC_File_Data'))
    if isfield(PSDipt.('SDC_File').Struct,'selectedfile')
        file = PSDipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load SDC Data',2);            
            load(file);
            saveData.path = file;
            PSDipt.([CallingLabel,'_Data']).('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSD.method = PSDipt.Func;
PSD.SDCS = PSDipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS;

Status2('done','',2);
Status2('done','',3);








