%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadGeneric_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

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
% Load Images
%--------------------------------------------
inds = strfind(Data1.file,'.');
type = Data1.file(inds(end)+1:end);
if strcmp(type,'hdr') || strcmp(type,'img')
    [IMG1,ImInfo] = Load_Analyze(Data1.file);
    IMG1.ImInfo = ImInfo;
elseif strcmp(type,'nii')
    [IMG1,ImInfo] = Load_Nifti(Data1.file);
    IMG1.Im = flip(IMG1.Im,3);
    IMG1.Im = flip(IMG1.Im,2);
    IMG1.Im(IMG1.Im == 0) = NaN;
    IMG1.ImInfo = ImInfo;
elseif strcmp(type,'mat')   
    [IMG1,ImInfo] = Load_Mat(Data1.file);
    IMG1.ImInfo = ImInfo;
end

%test = sum(isnan(IMG1.Im(:)));
%test2 = sum(IMG1.Im(:) == 0);

%--------------------------------------------
% Get Names
%--------------------------------------------
IMG1.path = Data1.path;
IMG1.file = Data1.file;
inds = strfind(IMG1.file,'\');
IMG1.name = IMG1.file(inds(end)+1:end-4);

%--------------------------------------------
% Make Sure Double
%--------------------------------------------
IMG1.Im = double(IMG1.Im);

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = IMG1;

Status2('done','',2);
Status2('done','',3);
