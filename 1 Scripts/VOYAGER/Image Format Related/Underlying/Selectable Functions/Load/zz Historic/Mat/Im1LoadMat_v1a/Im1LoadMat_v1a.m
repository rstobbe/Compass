%=========================================================
% (v1a) 
%       - same as FImageLoad1 (fix loading after save)
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadMat_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Two Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
global TOTALGBL

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
PanelLabel = 'Image_File';
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
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,LoadType,Path,File);
    Data1 = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
else 
    LoadAll = 0;
    if not(isfield(IMLDipt,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    if LoadAll == 1 || not(isfield(IMLDipt.([CallingLabel,'_Data']),[PanelLabel,'_Data']))
        if isfield(IMLDipt.(PanelLabel).Struct,'selectedfile')
            file = IMLDipt.(PanelLabel).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel];
                ErrDisp(err);
                return
            else
                Status2('busy','Load Image1 Data',2);
                load(file);
                saveData.path = file;
                IMLDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel];
            ErrDisp(err);
            return
        end
    end
    Gbl = IMLDipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);   
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
        err.msg = 'Image_File Selection Does Not Contain An Image';
        return
    end    
end

%--------------------------------------------
% Return ImInfo
%--------------------------------------------
if isfield(Data1,'ReconPars')
    ImvoxTB = Data1.ReconPars.ImvoxTB;
    ImvoxLR = Data1.ReconPars.ImvoxLR;
    ImvoxIO = Data1.ReconPars.ImvoxIO;
else
    ImvoxTB = 1;
    ImvoxLR = 1;
    ImvoxIO = 1;
end
ImInfo.pixdim = [ImvoxTB,ImvoxLR,ImvoxIO];
ImInfo.vox = ImvoxTB*ImvoxLR*ImvoxIO;
ImInfo.info = Data1.ExpDisp;
Data1.ImInfo = ImInfo;

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG = Data1;

Status2('done','',2);
Status2('done','',3);
