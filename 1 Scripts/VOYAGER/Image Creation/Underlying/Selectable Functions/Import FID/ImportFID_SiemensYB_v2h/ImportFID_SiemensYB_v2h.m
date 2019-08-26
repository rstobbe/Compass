%=========================================================
% (v2h)
%      - Add Options Function
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFID_SiemensYB_v2h(SCRPTipt,SCRPTGBL,FIDipt)

Status2('busy','Load FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.optfunc = FIDipt.('ImportFidOptfunc').Func;
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
% Get Working Structures from Sub Functions
%---------------------------------------------
OPTipt = FIDipt.('ImportFidOptfunc');
if isfield(FIDipt,([CallingLabel,'_Data']))
    if isfield(FIDipt.([CallingLabel,'_Data']),'ImportFidOptfunc_Data')
        OPTipt.('ImportFidOptfunc_Data') = FIDipt.([CallingLabel,'_Data']).('ImportFidOptfunc_Data');
    end
end

%------------------------------------------
% Get  Info
%------------------------------------------
func = str2func(FID.optfunc);           
[SCRPTipt,OPT,err] = func(SCRPTipt,OPTipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.OPT = OPT;

Status2('done','',2);
Status2('done','',3);