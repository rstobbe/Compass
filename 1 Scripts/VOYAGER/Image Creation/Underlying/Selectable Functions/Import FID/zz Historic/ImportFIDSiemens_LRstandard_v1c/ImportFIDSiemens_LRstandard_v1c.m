%=========================================================
% (v1c)
%      - Selection for FoV Shift Correction 
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFIDSiemens_LRstandard_v1c(SCRPTipt,SCRPTGBL,FIDipt)

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
FID.dccorfunc = FIDipt.('DCcorfunc').Func;
FID.visuals = FIDipt.('Visuals');
FID.fovadjust = FIDipt.('FovAdjust');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = FIDipt.Struct.labelstr;
DCCORipt = FIDipt.('DCcorfunc');
if isfield(FIDipt,([CallingLabel,'_Data']))
    if isfield(FIDipt.([CallingLabel,'_Data']),'DCcorfunc_Data')
        DCCORipt.('DCcorfunc_Data') = FIDipt.([CallingLabel,'_Data']).('DCcorfunc_Data');
    end
end

%------------------------------------------
% Get DC correction Function Info
%------------------------------------------
func = str2func(FID.dccorfunc);           
[SCRPTipt,DCCOR,err] = func(SCRPTipt,DCCORipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
FID.DCCOR = DCCOR;

Status2('done','',2);
Status2('done','',3);