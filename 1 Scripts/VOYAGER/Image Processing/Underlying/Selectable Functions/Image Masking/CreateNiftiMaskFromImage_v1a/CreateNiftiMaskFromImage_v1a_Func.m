%=====================================================
%
%=====================================================

function [MASKTOP,err] = CreateNiftiMaskFromImage_v1a_Func(MASKTOP,INPUT)

Status2('busy','Create Nifti Mask From Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
MASK = MASKTOP.MASK;
clear INPUT;

%---------------------------------------------
% Create Mask
%--------------------------------------------- 
func = str2func([MASKTOP.maskfunc,'_Func']);  
INPUT.Im = Im;                  
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
Im = MASK.Mask;

%---------------------------------------------
% SaveAsNifti
%---------------------------------------------
Im = permute(Im,[2 1 3]);
Im = flip(Im,2);    
[filename,folder] = uiputfile('*.nii','Name Export Image File',[IMG.path,'CMASK_',IMG.name]);
if filename == 0
    err.flag = 4;
    err.msg = '';
    return
end
filename = filename(1:end-4);        

%---------------------------------------------
% Export
%---------------------------------------------
if isfield(IMG,'ReconPars')
    voxeldims = [IMG.ReconPars.ImvoxLR IMG.ReconPars.ImvoxTB IMG.ReconPars.ImvoxIO];
else
    voxeldims = IMG.IMDISP.ImInfo.pixdim;
end
voxeldims = voxeldims([2 1 3]);
origin = size(Im).*voxeldims/2;
%origin(3) = origin(3)*1.3;
datatype = 'int16';
if strcmp(datatype,'int16')
    datatype = 4;
end
description = [];
nii = MakeNiftiHeaderYB_v1a(Im,voxeldims,origin,datatype,description); 
%hist = nii.hdr.hist
save_nii(nii,[folder,filename,'.nii']);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASKTOP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = PanelOutput;
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im;
if strfind(IMG.name,'.')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = ['CMASK_',IMG.name];
MASKTOP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



