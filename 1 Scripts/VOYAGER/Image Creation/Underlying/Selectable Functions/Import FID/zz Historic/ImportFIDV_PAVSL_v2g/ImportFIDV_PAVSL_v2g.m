%=========================================================
% (v2g)
%      - Update 'AutoGlobal' -> ExtRunInfo 
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFIDV_PAVSL_v2g(SCRPTipt,SCRPTGBL,FIDipt)

Status2('busy','Load FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID.method = FIDipt.Func;
PanelLabel = 'FIDpath';
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
    Path = ExtRunInfo.fidpath;
    File = '';
    LoadType = 'FID';
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,LoadType,Path,File);
    FID.path = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']).path;
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
                FIDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']).path = file;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel];
            ErrDisp(err);
            return
        end
    end
    FID.path = FIDipt.([CallingLabel,'_Data']).('FIDpath_Data').path;
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.DatName = FIDipt.('FIDpath').EntryStr;
FID.dccorfunc = FIDipt.('DCcorfunc').Func;
FID.visuals = FIDipt.('Visuals');

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