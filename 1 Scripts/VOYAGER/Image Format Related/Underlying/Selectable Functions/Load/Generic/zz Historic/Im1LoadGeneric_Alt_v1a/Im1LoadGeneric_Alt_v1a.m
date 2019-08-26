%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadGeneric_Alt_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
permute0 = IMLDipt.('Permute');
IMLD.flip1 = IMLDipt.('Flip1');
IMLD.flip2 = IMLDipt.('Flip2');
IMLD.flip3 = IMLDipt.('Flip3');
PanelLabel1 = 'Image_File';
CallingLabel = IMLDipt.Struct.labelstr;

%---------------------------------------------
% Permute
%---------------------------------------------
for n = 1:3
    IMLD.permute(n) = str2double(permute0(n));
end

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
    IMG1.Im = analyze75read(Data1.file);
    IMG1.Im = flipdim(IMG1.Im,1);
    IMG1.Im = flipdim(IMG1.Im,3);    
    test = analyze75info(Data1.file);
    pixdim = test.PixelDimensions;
    ReconPars.ImvoxLR = pixdim(1);
    ReconPars.ImvoxTB = pixdim(2);    
    ReconPars.ImvoxIO = pixdim(3);  
    IMG1.ReconPars = ReconPars;
elseif strcmp(type,'nii')
    out = load_nii(Data1.file);
    IMG1.Im = out.img;
    IMG1.Im = permute(IMG1.Im,[2 1 3]);
    IMG1.Im = flipdim(IMG1.Im,1);
    IMG1.Im = flipdim(IMG1.Im,2);
    IMG1.Im = flipdim(IMG1.Im,3);
elseif strcmp(type,'mat')   
    load(Data1.file)
    fields = fieldnames(saveData);
    foundimage = 0;
    for n = 1:length(fields)
        if isfield(saveData.(fields{n}),'Im')
            IMG1 = saveData.(fields{n});
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
% Get Names
%--------------------------------------------
IMG1.path = Data1.path;
IMG1.file = Data1.file;
inds = strfind(IMG1.file,'\');
IMG1.name = IMG1.file(inds(end)+1:end-4);

%--------------------------------------------
% Alter Orientation
%--------------------------------------------
Im = double(IMG1.Im);
Im = permute(Im,IMLD.permute);
if strcmp(IMLD.flip1,'Yes')
    Im = flipdim(Im,1);
end
if strcmp(IMLD.flip2,'Yes')
    Im = flipdim(Im,2);
end
if strcmp(IMLD.flip3,'Yes')
    Im = flipdim(Im,3);
end
IMG1.Im = Im;

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = IMG1;


Status2('done','',2);
Status2('done','',3);
