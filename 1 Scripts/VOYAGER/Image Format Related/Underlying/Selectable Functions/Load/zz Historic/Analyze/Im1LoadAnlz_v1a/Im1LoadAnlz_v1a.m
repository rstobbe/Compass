%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadAnlz_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Analyze Image',2);
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

%--------------------------------------------
% Load Analyze Images
%--------------------------------------------
%info = analyze75info(Data1.file)
IMG1.Im = analyze75read(Data1.file);
IMG1.Im = flipdim(IMG1.Im,1);

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = IMG1;

Status2('done','',2);
Status2('done','',3);
