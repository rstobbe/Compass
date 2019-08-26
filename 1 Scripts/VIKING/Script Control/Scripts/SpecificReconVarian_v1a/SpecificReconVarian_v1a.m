%====================================================
% (v1a)
%   
%====================================================
 
function [SCRPTipt,SCRPTGBL,err] = SpecificReconVarian_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Image from Prisma');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Data_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Data_File').Struct,'selectedpath')
        path = SCRPTGBL.CurrentTree.('Data_File').Struct.selectedpath;
        if not(exist(path,'dir'))
            err.flag = 1;
            err.msg = '(Re) Load Data_File';
            ErrDisp(err);
            return
        else
            saveData.path = path;
            SCRPTGBL.('Data_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Data_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'ReconScript_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ReconScript').Struct,'selectedpath')
        path = SCRPTGBL.CurrentTree.('ReconScript').Struct.selectedpath;
        if not(exist(path,'dir'))
            err.flag = 1;
            err.msg = '(Re) Load ReconScript';
            ErrDisp(err);
            return
        else
            error;          % should load here
            saveData.path = path;
            SCRPTGBL.('ReconScript_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ReconScript';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RECON.method = SCRPTGBL.CurrentTree.Func;
Data = SCRPTGBL.('Data_File_Data');
Recon = SCRPTGBL.('ReconScript_Data');
 
%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([RECON.method,'_Func']);
INPUT.Data = Data;
INPUT.Recon = Recon;
INPUT.RWSUI = SCRPTGBL.RWSUI;
[RECON,err] = func(INPUT,RECON);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



