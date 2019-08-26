%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = FLImageLoad1_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
global TOTALGBL

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
IMLD.load = IMLDipt.('Load');
PanelLabel = 'Image_File';
CallingLabel = IMLDipt.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
auto = 0;
totalgbl = 0;
val = get(findobj('tag','totalgbl'),'value');
if not(isempty(val)) && val(1) ~= 0
    Gbl = TOTALGBL{2,val};
    totalgbl = 1;
    if isfield(Gbl,'AutoRecon')
        auto = 1;
    end
end

%---------------------------------------------
% Get Image
%---------------------------------------------
searchforimage = 0;
if auto == 1
    Path = Gbl.Path;
    File = ['IMG_',Gbl.SaveName];
    LoadType = 'Image';
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,LoadType,Path,File);
    Gbl = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
    searchforimage = 1;
elseif strcmp(IMLD.load,'Local')
    if totalgbl == 0;
        err.flag = 1;
        err.msg = 'No Image in Global Memory';
        return  
    end
    if not(isfield(Gbl,'Im'))
        err.flag = 1;
        err.msg = 'Global Does Not Contain Image';
        return
    end
    %Path = Gbl.path;
    %File = Gbl.name;
    %LoadType = 'Image';
    %[SCRPTipt,SCRPTGBL,err] = Global2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,LoadType,Path,File,Gbl);
    %Data = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
    Data = Gbl;
elseif strcmp(IMLD.load,'File')   
    LoadAll = 0;
    if not(isfield(IMLDipt,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    if LoadAll == 1 || not(isfield(IMLDipt.([CallingLabel,'_Data']),[PanelLabel,'_Data']))
        if isfield(IMLDipt.(PanelLabel).Struct,'selectedfile')
            file = IMLDipt.(PanelLabel).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Image_File';
                ErrDisp(err);
                return
            else
                Status2('busy','Load Image Data',2);
                load(file);
                saveData.path = file;
                IMLDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load Image_File';
            ErrDisp(err);
            return
        end
    end
    Gbl = IMLDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
    searchforimage = 1;
end

%--------------------------------------------
% Search for Image
%--------------------------------------------
if searchforimage == 1
    fields = fieldnames(Gbl);
    foundimage = 0;
    for n = 1:length(fields)
        if isfield(Gbl.(fields{n}),'Im')
            Data = Gbl.(fields{n});
            foundimage = 1;
            break
        end
    end
    if foundimage == 0;
        err.flag = 1;
        err.msg = 'Image_File Selection Does Not Contain An Image';
        return
    end  
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
if isfield(Data,'ExpDisp');
    set(findobj('tag','TestBox'),'string',Data.ExpDisp);
end

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG = Data;

Status2('done','',2);
Status2('done','',3);
