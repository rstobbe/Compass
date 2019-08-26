%====================================================
% (v1b)
%      
%====================================================
 
function [SCRPTipt,SCRPTGBL,err] = SpecificReconSiemens_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Image from Prisma');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Where to Load
%-------------------------------------------
RWSUI = SCRPTGBL.RWSUI;
if RWSUI.panelnum ~= 5;
    err.flag = 1;
    err.msg = 'Run Composite Script Panel';
    return
end
if strcmp(RWSUI.tab,'IM')
    RWSUI.tab = 'ACC';
end

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
if isfield(SCRPTGBL.CurrentTree.('ReconScript').Struct,'selectedfile')
    path = SCRPTGBL.CurrentTree.('ReconScript').Struct.selectedpath;
    file = SCRPTGBL.CurrentTree.('ReconScript').Struct.selectedfilename;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Select ReconScript';
        ErrDisp(err);
        return
    end
else
    err.flag = 1;
    err.msg = 'Select ReconScript';
    ErrDisp(err);
    return
end

%---------------------------------------------
% Load (if needed)
%---------------------------------------------
[err] = ExtLoadComposite(RWSUI.tab,file,path);
if err.flag
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RECON.method = SCRPTGBL.CurrentTree.Func;
RECON.name = SCRPTGBL.CurrentTree.('Name');
RECON.file = SCRPTGBL.('Data_File_Data');

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([RECON.method,'_Func']);
INPUT.RWSUI = SCRPTGBL.RWSUI;
INPUT.SCRPTipt = SCRPTipt;
[RECON,err] = func(INPUT,RECON);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



