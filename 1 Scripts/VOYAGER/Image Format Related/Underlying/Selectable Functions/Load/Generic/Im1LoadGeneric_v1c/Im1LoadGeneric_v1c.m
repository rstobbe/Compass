%=========================================================
% (v1c)
%      - Update 'AutoGlobal' -> ExtRunInfo 
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadGeneric_v1c(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
PanelLabel1 = 'Image1_File';
CallingLabel = IMLDipt.Struct.labelstr;

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
% Get Image
%---------------------------------------------
if auto == 1
    [IMG,ImInfo,err] = Load_Mat_RWS(ExtRunInfo);
    if err.flag
        return
    end
    Path = IMG.path;
    File = [IMG.name,'.mat'];
    LoadType = 'Image';
    [SCRPTipt,SCRPTGBL,err] = Global2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel1,LoadType,Path,File,ExtRunInfo.saveData);
    Data.IMG = IMG;
    Data.path = Path;
else
    LoadAll = 0;
    if not(isfield(IMLDipt,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    if LoadAll == 1 || not(isfield(IMLDipt.([CallingLabel,'_Data']),[PanelLabel1,'_Data']))
        if isfield(IMLDipt.(PanelLabel1).Struct,'selectedfile')
            file = IMLDipt.(PanelLabel1).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel1];
                ErrDisp(err);
                return
            else
                Status2('busy','Load Image1 Data',2);
                ind = strfind(file,'\');
                filename = file(ind(end)+1:end);
                path = file(1:ind(end));
                [IMG,~,~,err] = Import_Image(path,filename);
                saveData.IMG = IMG;
                saveData.path = path;
                IMLDipt.([CallingLabel,'_Data']).([PanelLabel1,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel1];
            ErrDisp(err);
            return
        end
    end
    Data = IMLDipt.([CallingLabel,'_Data']).([PanelLabel1,'_Data']);   
end

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = Data.IMG;
IMLD.axnum = 1;

Status2('done','',2);
Status2('done','',3);
