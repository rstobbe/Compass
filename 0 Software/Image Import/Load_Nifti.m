%===================================================
% 
%===================================================

function [IMG,ImInfo,err] = Load_Nifti(Imfile)

err.flag = 0;
err.msg = '';
ImInfo = '';

button = questdlg('Load Nifti Method','Load Nifti','Standard','Untouch','Reslice','Standard');
if strcmp(button,'Standard') 
    out = load_nii(Imfile);                             % load with rotations
elseif strcmp(button,'Untouch')
    out = load_untouch_nii(Imfile); 
elseif strcmp(button,'Reslice')
    ind = strfind(Imfile,'\');
    NewName = [Imfile(1:ind(end)),'r',Imfile(ind(end)+1:end)];
    reslice_nii(Imfile,NewName); 
    out = load_nii(NewName);
else
    err.flag = 4;
    err.msg = '';
end          
%---
%hdr = out.hdr;
%hk = hdr.hk
%dime = hdr.dime
%hist = hdr.hist
%pixdim = dime.pixdim
%---
Im = double(out.img);
if isfield(out.hdr.hist,'descrip')
    descrip = out.hdr.hist.descrip;
else
    descrip = [];
end
pixdim = out.hdr.dime.pixdim;

ImInfo.pixdim = [pixdim(3),pixdim(2),pixdim(4)];  % Old NIFTI orientation
ImInfo.vox = pixdim(3)*pixdim(2)*pixdim(4);
%---
ImInfo.acqorient = 'Axial';                     % for now
ImInfo.baseorient = 'Axial';  
%---
ImInfo.info = '';

%---------------------------------
Im = permute(Im,[2 1 3 4 5 6]);                 % NIFTI orientation - don't change (problem elsewehere)
Im = flip(Im,1);                               
%---------------------------------

if strcmp(button,'ExploreDTI')
    Im = flip(Im,2);                            % ExploreDTI exports weird... (at least that's my contention
end

ImInfo.dims = size(Im);

ReconPars.ImvoxTB = round(ImInfo.pixdim(1)*100)/100;
ReconPars.ImvoxLR = round(ImInfo.pixdim(2)*100)/100;  
ReconPars.ImvoxIO = round(ImInfo.pixdim(3)*100)/100;  

IMG.Im = Im;
IMG.ReconPars = ReconPars;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'File',Imfile,'Output'};
Panel(3,:) = {'Description',descrip,'Output'};
%Panel(4,:) = {'Pixdim',pixdim,'Output'};
IMG.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
