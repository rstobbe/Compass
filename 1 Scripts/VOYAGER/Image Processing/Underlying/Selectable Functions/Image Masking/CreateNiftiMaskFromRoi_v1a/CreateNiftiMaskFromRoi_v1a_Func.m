%=====================================================
%
%=====================================================

function [MASK,err] = CreateNiftiMaskFromRoi_v1a_Func(MASK,INPUT)

Status2('busy','Create Mask From Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Turn ROI into Mask
%---------------------------------------------
load(MASK.ROI.selectedfile,'ROI');
sz1 = size(IMG.Im);
sz2 = size(ROI.roimask);
if sz1(1)~=sz2(1) || sz1(2)~=sz2(2) || sz1(3)~=sz2(3)
    err.flag = 1;
    err.msg = 'Image and ROI do not match';
end
Im = ROI.roimask;

%---------------------------------------------
% SaveAsNifti
%---------------------------------------------
Im = permute(Im,[2 1 3]);
Im = flip(Im,2);    
[filename,folder] = uiputfile('*.nii','Name Export Image File',[MASK.ROI.selectedpath,'MASK_',ROI.roiname]);
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
%voxeldims = voxeldims([2 1 3]);
%origin = size(Im).*voxeldims/2;
origin = (size(Im)-1).*voxeldims/2;
datatype = 'int16';
if strcmp(datatype,'int16')
    datatype = 4;
end
if isfield(IMG,'hdr')
    datatype = IMG.hdr.dime.datatype;
end
datatype = 512;
Im(isnan(Im)) = 0;
description = [];
nii = MakeNiftiHeaderYB_v1a(Im,voxeldims,origin,datatype,description); 
if isfield(IMG,'hdr')
    nii.hdr = IMG.hdr;
end
save_nii(nii,[folder,filename,'.nii']);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = [PanelOutput];
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.name = ['MASK_',ROI.roiname];
MASK.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



