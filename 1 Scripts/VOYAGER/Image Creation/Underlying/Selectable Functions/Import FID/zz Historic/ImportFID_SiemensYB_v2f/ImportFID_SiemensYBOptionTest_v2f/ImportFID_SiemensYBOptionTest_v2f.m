%=========================================================
% (v2f)
%      - include Multi-Echo capability
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFID_SiemensYBOptionTest_v2f(SCRPTipt,SCRPTGBL,FIDipt)

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
        err.flag = 1;
        err.msg = ['(Re) Load ',PanelLabel];                % reload each time saved script loaded
        ErrDisp(err);
        return
    end
    FID.DATA = FIDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.visuals = FIDipt.('Visuals');
FID.rcvrtest = FIDipt.('DoReceiver');
FID.fovadjust = FIDipt.('FovAdjust');
FID.doaveraging = FIDipt.('DoAveraging');

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