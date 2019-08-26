%=========================================================
% (v1a) 
%       - same as F2ImagesLoad (fix loading after save)
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im2LoadMat_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Two Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
global TOTALGBL

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
PanelLabel1 = 'Image1_File';
PanelLabel2 = 'Image2_File';
CallingLabel = IMLDipt.Struct.labelstr;

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
% Get Image
%---------------------------------------------
if auto == 1
    Path = Gbl.Path1;
    File = Gbl.SaveName1;
    LoadType = 'Image';
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel1,LoadType,Path,File);
    Data1 = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel1,'_Data']);
    %--
    Path = Gbl.Path2;
    File = Gbl.SaveName2;
    LoadType = 'Image';
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel2,LoadType,Path,File);
    Data2 = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel2,'_Data']);
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
                load(file);
                saveData.path = file;
                IMLDipt.([CallingLabel,'_Data']).([PanelLabel1,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel1];
            ErrDisp(err);
            return
        end
    end
    Gbl = IMLDipt.([CallingLabel,'_Data']).([PanelLabel1,'_Data']);   
    test = Gbl.IMG
    fields = fieldnames(Gbl);
    foundimage = 0;
    for n = 1:length(fields)
        if isfield(Gbl.(fields{n}),'Im')
            Data1 = Gbl.(fields{n});
            foundimage = 1;
            break
        end
    end
    if foundimage == 0;
        err.flag = 1;
        err.msg = 'Image_File1 Selection Does Not Contain An Image';
        return
    end
    %--
    if LoadAll == 1 || not(isfield(IMLDipt.([CallingLabel,'_Data']),[PanelLabel2,'_Data']))
        if isfield(IMLDipt.(PanelLabel2).Struct,'selectedfile')
            file = IMLDipt.(PanelLabel2).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel2];
                ErrDisp(err);
                return
            else
                Status2('busy','Load Image2 Data',2);
                load(file);
                saveData.path = file;
                IMLDipt.([CallingLabel,'_Data']).([PanelLabel2,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel2];
            ErrDisp(err);
            return
        end
    end
    Gbl = IMLDipt.([CallingLabel,'_Data']).([PanelLabel2,'_Data']);   
    fields = fieldnames(Gbl);
    foundimage = 0;
    for n = 1:length(fields)
        if isfield(Gbl.(fields{n}),'Im')
            Data2 = Gbl.(fields{n});
            foundimage = 1;
            break
        end
    end
    if foundimage == 0;
        err.flag = 1;
        err.msg = 'Image_File2 Selection Does Not Contain An Image';
        return
    end  
    
end

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = Data1;
IMLD.IMG{2} = Data2;

Status2('done','',2);
Status2('done','',3);
