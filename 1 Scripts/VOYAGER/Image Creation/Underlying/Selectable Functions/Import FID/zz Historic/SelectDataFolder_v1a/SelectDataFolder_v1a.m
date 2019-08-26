%=========================================================
% (v1a)
%       - 
%=========================================================

function [SCRPTipt,SCRPTGBL,DIR,err] = SelectDataFolder_v1a(SCRPTipt,SCRPTGBL,DIRipt)

Status2('busy','Select Data Folder',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';
global TOTALGBL

%---------------------------------------------
% Get Input
%---------------------------------------------
DIR.method = DIRipt.Func;
PanelLabel = 'DataDir';
CallingLabel = DIRipt.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
auto = 0;
val = get(findobj('tag','totalgbl'),'value');
if not(isempty(val)) && val(1) ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        auto = 1;
    end
end

%---------------------------------------------
% Get Directory
%---------------------------------------------
if auto == 1
    Path = Gbl.Path;
    File = '';
    LoadType = 'Directory';
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,LoadType,Path,File);
    Gbl = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
else  
    LoadAll = 0;
    if not(isfield(DIRipt,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    if LoadAll == 1 || not(isfield(DIRipt.([CallingLabel,'_Data']),[PanelLabel,'_Data']))
        if isfield(DIRipt.(PanelLabel).Struct,'selectedfile')
            file = DIRipt.(PanelLabel).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load DataDir';
                ErrDisp(err);
                return
            else
                Status2('busy','Load DataDir',2);
                saveData.path = file;
                DIRipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load DataDir';
            ErrDisp(err);
            return
        end
    end
    Gbl = DIRipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);     
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DIR.method = DIRipt.Func;
DIR.DataDir = Gbl.path;

Status2('done','',2);
Status2('done','',3);




