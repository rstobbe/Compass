%====================================================
% (v1b)
%      
%====================================================
 
function [SCRPTipt,SCRPTGBL,err] = FlexFolderCreate_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Create Images In Folder');
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
if not(isfield(SCRPTGBL,'Folder_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Folder').Struct,'selectedpath')
        path = SCRPTGBL.CurrentTree.('Folder').Struct.selectedpath;
        if not(exist(path,'dir'))
            err.flag = 1;
            err.msg = '(Re) Load Folder';
            ErrDisp(err);
            return
        else
            saveData.path = path;
            SCRPTGBL.('Folder_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Folder';
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
scrptnum = 1;
panelnum = 1;
[err] = ExtLoadScrptDefault(RWSUI.tab,panelnum,scrptnum,file,path);
if err.flag
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RECON.method = SCRPTGBL.CurrentTree.Func;
RECON.folder = SCRPTGBL.('Folder_Data');

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



