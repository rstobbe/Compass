%=========================================================
% (v2c)
%      - Same as 'ImportFIDSiemens_LRstandard_v1c' (function identical) 
%      - no input options 
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFID_SiemensYB_v2c(SCRPTipt,SCRPTGBL,FIDipt)

Status2('busy','Load FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID.method = FIDipt.Func;
PanelLabel = 'Data_File';
CallingLabel = FIDipt.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
auto = 0;
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    auto = 1;
    ExtRunInfo = RWSUI.ExtRunInfo;
end

%---------------------------------------------
% Tests
%---------------------------------------------
if auto == 1
    saveData = ExtRunInfo.saveData;
    [SCRPTipt,SCRPTGBL,err] = Siemens2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,saveData);
    FID.DATA = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
else
    if not(isfield(FIDipt,[CallingLabel,'_Data']))
        if isfield(FIDipt.(PanelLabel).Struct,'selectedfile')
            file = FIDipt.(PanelLabel).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel];
                ErrDisp(err);
                return
            else
                FIDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']).loc = file;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel];
            ErrDisp(err);
            return
        end
    end
    FID.DATA = FIDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.visuals = 'No';
FID.fovadjust = 'Yes';

%---------------------------------------------
% DC correction
%---------------------------------------------
DCCOR.method = 'DCcor_None_v1a';

%---------------------------------------------
% Return
%---------------------------------------------
FID.DCCOR = DCCOR;

Status2('done','',2);
Status2('done','',3);