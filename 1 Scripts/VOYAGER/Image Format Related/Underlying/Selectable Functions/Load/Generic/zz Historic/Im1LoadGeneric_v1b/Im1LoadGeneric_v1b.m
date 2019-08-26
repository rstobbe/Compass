%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadGeneric_v1b(SCRPTipt,SCRPTGBL,IMLDipt)

global TOTALGBL

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
val = length(TOTALGBL(1,:));
if not(isempty(val)) && val(1) ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        auto = 1;
    end
end

%---------------------------------------------
% Get Image
%---------------------------------------------
if auto == 1
    Path = Gbl.Path;
    File = ['IMG_',Gbl.SaveName];
    LoadType = 'Image';
    if strcmp(TOTALGBL{1,val-1},File)
        [SCRPTipt,SCRPTGBL,err] = Global2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel1,LoadType,Path,File,TOTALGBL{2,val-1});
    else
        error;
        %[SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel1,LoadType,Path,File);    % probably don't use...
    end
    Data.IMG = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel1,'_Data']);
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

Status2('done','',2);
Status2('done','',3);
