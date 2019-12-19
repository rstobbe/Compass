%=====================================================
%
%=====================================================

function [MASKTOP,err] = SeparateNiftiColourImage_v1a_Func(MASKTOP,INPUT)

Status2('busy','Separate Nifti Colour Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
clear INPUT;

if not(isfield(IMG,'hdr'))
    err.flag = 1;
    err.msg = 'Not Nifti Imaging';
end

%---------------------------------------------
% SaveAsNifti
%---------------------------------------------
[filename,folder] = uiputfile('*.nii','Name Export Image File',[IMG.path,'X',IMG.name]);
if filename == 0
    err.flag = 4;
    err.msg = '';
    return
end
filename = filename(2:end-4);        

%---------------------------------------------
% Export
%---------------------------------------------
Im = permute(Im,[2 1 3 4]);
Im = flip(Im,2);    
if isfield(IMG,'ReconPars')
    voxeldims = [IMG.ReconPars.ImvoxLR IMG.ReconPars.ImvoxTB IMG.ReconPars.ImvoxIO];
else
    voxeldims = IMG.IMDISP.ImInfo.pixdim;
end
origin = (size(Im(:,:,:,1))-1).*voxeldims/2;
datatype = IMG.hdr.dime.datatype;
Im(isnan(Im)) = 0;
description = [];

carr = 'XYZ';
for n = 1:3
    Im0 = Im(:,:,:,n);
    nii = MakeNiftiHeaderYB_v1a(Im0,voxeldims,origin,datatype,description); 
    nii.hdr = IMG.hdr;
    filename0 = [carr(n),filename];
    save_nii(nii,[folder,filename0,'.nii']);
end

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
MASKTOP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



