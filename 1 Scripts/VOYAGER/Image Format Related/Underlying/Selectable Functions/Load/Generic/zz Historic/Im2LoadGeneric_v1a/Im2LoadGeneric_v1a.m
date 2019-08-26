%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im2LoadGeneric_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load 2 Images',2);
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
% Get Names
%--------------------------------------------
IMG1.path = Data1.path;
IMG1.file = Data1.file;
inds = strfind(IMG1.file,'\');
IMG1.name = IMG1.file(inds(end)+1:end-4);

IMG2.path = Data2.path;
IMG2.file = Data2.file;
inds = strfind(IMG2.file,'\');
IMG2.name = IMG2.file(inds(end)+1:end-4);

%--------------------------------------------
% Load Images
%--------------------------------------------
inds = strfind(IMG1.file,'.');
type = IMG1.file(inds(end)+1:end);
if strcmp(type,'hdr') || strcmp(type,'img')
    IMG1.Im = analyze75read(Data1.file);
    IMG1.Im = flipdim(IMG1.Im,1);
    IMG1.Im = flipdim(IMG1.Im,3);    
    %test = analyze75info(Data1.file);
    %IMINFO(Nim).pixdim = test.PixelDimensions;
    %IMINFO(Nim).vox = IMINFO(Nim).pixdim(1)*IMINFO(Nim).pixdim(2)*IMINFO(Nim).pixdim(3);    
elseif strcmp(type,'nii')
    out = load_nii(Data1.file);
    IMG1.Im = out.img;
    IMG1.Im = permute(IMG1.Im,[2 1 3]);
    IMG1.Im = flipdim(IMG1.Im,1);
    IMG1.Im = flipdim(IMG1.Im,2);
    IMG1.Im = flipdim(IMG1.Im,3);
elseif strcmp(type,'mat')   
    load(Data1.file)
    IMG1 = saveData.IMG;
end
%---
inds = strfind(IMG2.file,'.');
type = IMG2.file(inds(end)+1:end);
if strcmp(type,'hdr') || strcmp(type,'img')
    IMG2.Im = analyze75read(Data2.file);
    IMG2.Im = flipdim(IMG2.Im,1);
    IMG2.Im = flipdim(IMG2.Im,3);      
    %test = analyze75info(Data1.file);
    %IMINFO(Nim).pixdim = test.PixelDimensions;
    %IMINFO(Nim).vox = IMINFO(Nim).pixdim(1)*IMINFO(Nim).pixdim(2)*IMINFO(Nim).pixdim(3);    
elseif strcmp(type,'nii')
    out = load_nii(Data2.file);
    IMG2.Im = out.img;
    IMG2.Im = permute(IMG2.Im,[2 1 3]);
    IMG2.Im = flipdim(IMG2.Im,1);
    IMG2.Im = flipdim(IMG2.Im,2);
    IMG2.Im = flipdim(IMG2.Im,3);
elseif strcmp(type,'mat')   
    load(Data2.file)
    IMG2 = saveData.IMG;
end

%--------------------------------------------
% Make Sure Double
%--------------------------------------------
IMG1.Im = double(IMG1.Im);
IMG2.Im = double(IMG2.Im);

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = IMG1;
IMLD.IMG{2} = IMG2;

Status2('done','',2);
Status2('done','',3);
