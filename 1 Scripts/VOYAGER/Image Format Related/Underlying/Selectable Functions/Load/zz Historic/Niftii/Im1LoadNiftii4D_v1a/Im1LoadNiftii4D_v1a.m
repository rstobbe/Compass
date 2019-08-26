%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = Im1LoadNiftii4D_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Niftii Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
IMLD.imnum = str2double(IMLDipt.('ImNum'));
PanelLabel1 = 'Image_File';
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
% Load Niftii Images
%--------------------------------------------
out = load_nii(Data1.file);
Im = out.img;
IMG.Im = squeeze(Im(:,:,:,IMLD.imnum));
IMG.Im = permute(IMG.Im,[2 1 3]);
IMG.Im = flipdim(IMG.Im,1);
IMG.Im = flipdim(IMG.Im,2);
IMG.Im = flipdim(IMG.Im,3);

IMG.path = Data1.path;
IMG.file = Data1.file;
inds = strfind(IMG.file,'\');
IMG.name = IMG.file(inds(end)+1:end-4);

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.IMG{1} = IMG;


Status2('done','',2);
Status2('done','',3);
