%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im2LoadAnlz_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load 2 Analyze Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
PanelLabel1 = 'Image1_File';
PanelLabel2 = 'Image2_File';
CallingLabel = IMLDipt.Struct.labelstr;

%---------------------------------------------
% Get Image
%---------------------------------------------
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
Data1 = IMLDipt.([CallingLabel,'_Data']).([PanelLabel1,'_Data']);   
%--
if LoadAll == 1 || not(isfield(IMLDipt.([CallingLabel,'_Data']),[PanelLabel2,'_Data']))
    if isfield(IMLDipt.(PanelLabel2).Struct,'selectedfile')
        file = IMLDipt.(PanelLabel2).Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel1];
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
        err.msg = ['(Re) Load ',PanelLabel1];
        ErrDisp(err);
        return
    end
end
Data2 = IMLDipt.([CallingLabel,'_Data']).([PanelLabel2,'_Data']);   

%--------------------------------------------
% Load Analyze Images
%--------------------------------------------
IMG1.Im = analyze75read(Data1.file);
IMG1.Im = flipdim(IMG1.Im,1);

%IMG2.Im = analyze75read(Data2.file);
%IMG2.Im = flipdim(IMG2.Im,1);
%IMG2.Im(IMG2.Im == 0) = NaN;

load(Data2.file)
IMG2 = saveData.IMG;

%test = analyze75info(Data1.file);
%IMINFO(Nim).pixdim = test.PixelDimensions;
%IMINFO(Nim).vox = IMINFO(Nim).pixdim(1)*IMINFO(Nim).pixdim(2)*IMINFO(Nim).pixdim(3);

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = IMG1;
IMLD.IMG{2} = IMG2;

Status2('done','',2);
Status2('done','',3);
